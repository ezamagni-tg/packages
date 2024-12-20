// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.videoplayer;

import android.os.Build;
import androidx.annotation.NonNull;
import androidx.annotation.OptIn;
import androidx.media3.common.C;
import androidx.media3.common.Format;
import androidx.media3.common.PlaybackException;
import androidx.media3.common.Player;
import androidx.media3.common.TrackGroup;
import androidx.media3.common.Tracks;
import androidx.media3.common.VideoSize;
import androidx.media3.common.util.UnstableApi;
import androidx.media3.exoplayer.ExoPlayer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Collection;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

final class ExoPlayerEventListener implements Player.Listener {
  private final ExoPlayer exoPlayer;
  private final VideoPlayerCallbacks events;
  private boolean isBuffering = false;
  private boolean isInitialized;

  private enum RotationDegrees {
    ROTATE_0(0),
    ROTATE_90(90),
    ROTATE_180(180),
    ROTATE_270(270);

    private final int degrees;

    RotationDegrees(int degrees) {
      this.degrees = degrees;
    }

    public static RotationDegrees fromDegrees(int degrees) {
      for (RotationDegrees rotationDegrees : RotationDegrees.values()) {
        if (rotationDegrees.degrees == degrees) {
          return rotationDegrees;
        }
      }
      throw new IllegalArgumentException("Invalid rotation degrees specified: " + degrees);
    }
  }

  ExoPlayerEventListener(ExoPlayer exoPlayer, VideoPlayerCallbacks events) {
    this(exoPlayer, events, false);
  }

  ExoPlayerEventListener(ExoPlayer exoPlayer, VideoPlayerCallbacks events, boolean initialized) {
    this.exoPlayer = exoPlayer;
    this.events = events;
    this.isInitialized = initialized;
  }

  private void setBuffering(boolean buffering) {
    if (isBuffering == buffering) {
      return;
    }
    isBuffering = buffering;
    if (buffering) {
      events.onBufferingStart();
    } else {
      events.onBufferingEnd();
    }
  }

    @OptIn(markerClass = UnstableApi.class)
    @SuppressWarnings("SuspiciousNameCombination")
  private void sendInitialized() {
    if (isInitialized) {
      return;
    }
    isInitialized = true;
    VideoSize videoSize = exoPlayer.getVideoSize();
    int rotationCorrection = 0;
    int width = videoSize.width;
    int height = videoSize.height;
    if (width != 0 && height != 0) {
      RotationDegrees reportedRotationCorrection = RotationDegrees.ROTATE_0;

      if (Build.VERSION.SDK_INT >= 29) {
        // The video's Format also provides a rotation correction that may be used to
        // correct the rotation, so we try to use that to correct the video rotation
        // when the ImageReader backend for Impeller is used.
        rotationCorrection = getRotationCorrectionFromFormat(exoPlayer);

        try {
          reportedRotationCorrection = RotationDegrees.fromDegrees(rotationCorrection);
        } catch (IllegalArgumentException e) {
          rotationCorrection = 0;
        }
      }

      // Switch the width/height if video was taken in portrait mode and a rotation
      // correction was detected.
      if (reportedRotationCorrection == RotationDegrees.ROTATE_90
          || reportedRotationCorrection == RotationDegrees.ROTATE_270) {
        width = videoSize.height;
        height = videoSize.width;
      }
    }

    AtomicReference<Integer> currentAudiotrackId = new AtomicReference<>();

    Tracks info = exoPlayer.getCurrentTracks();
    List<Map<String, Object>> availableTracks = info.getGroups()
            .stream()
            .filter(trackGroupInfo -> trackGroupInfo.getType() == C.TRACK_TYPE_AUDIO)
            .map((trackGroupInfo) -> {
              List<HashMap<String, Object>> trackList = new ArrayList<>();

              TrackGroup trackGroup = trackGroupInfo.getMediaTrackGroup();

              for (int i = 0; i < trackGroup.length; i++) {
                String id = trackGroup.getFormat(i).id;
                String name = trackGroup.getFormat(i).label;
                String language = trackGroup.getFormat(i).language;

                if (id != null && language != null) {
                  if (trackGroupInfo.isTrackSelected(i)) {
                    currentAudiotrackId.set(id.hashCode());
                  }
                  Locale languageLocale = new Locale(language);
                  HashMap<String, Object> track = new HashMap<>();
                  track.put("id", id.hashCode());
                  track.put("language", languageLocale.getISO3Language());

                  if (name != null) {
                    track.put("name", name);
                  }
                  trackList.add(track);
                }
              }

              return trackList;
            })
            .flatMap(Collection::stream)
            .collect(Collectors.toCollection(ArrayList::new));

    events.onInitialized(width, height, exoPlayer.getDuration(), rotationCorrection, currentAudiotrackId.get(), availableTracks);
  }

  @OptIn(markerClass = androidx.media3.common.util.UnstableApi.class)
  // A video's Format and its rotation degrees are unstable because they are not guaranteed
  // the same implementation across API versions. It is possible that this logic may need
  // revisiting should the implementation change across versions of the Exoplayer API.
  private int getRotationCorrectionFromFormat(ExoPlayer exoPlayer) {
    Format videoFormat = Objects.requireNonNull(exoPlayer.getVideoFormat());
    return videoFormat.rotationDegrees;
  }

  @Override
  public void onPlaybackStateChanged(final int playbackState) {
    switch (playbackState) {
      case Player.STATE_BUFFERING:
        setBuffering(true);
        events.onBufferingUpdate(exoPlayer.getBufferedPosition());
        break;
      case Player.STATE_READY:
        sendInitialized();
        break;
      case Player.STATE_ENDED:
        events.onCompleted();
        break;
      case Player.STATE_IDLE:
        break;
    }
    if (playbackState != Player.STATE_BUFFERING) {
      setBuffering(false);
    }
  }

  @Override
  public void onPlayerError(@NonNull final PlaybackException error) {
    setBuffering(false);
    if (error.errorCode == PlaybackException.ERROR_CODE_BEHIND_LIVE_WINDOW) {
      // See https://exoplayer.dev/live-streaming.html#behindlivewindowexception-and-error_code_behind_live_window
      exoPlayer.seekToDefaultPosition();
      exoPlayer.prepare();
    } else {
      events.onError("VideoError", "Video player had error " + error, null);
    }
  }

  @Override
  public void onIsPlayingChanged(boolean isPlaying) {
    events.onIsPlayingStateUpdate(isPlaying);
  }
}
