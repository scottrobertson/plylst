class AudioFeaturesWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :slow

  def perform(track_ids)
    spotify_tracks = RSpotify::AudioFeatures.find(track_ids)
    tracks = Track.where(spotify_id: track_ids)
    
    spotify_tracks.each do |spotify_track|
      track = tracks.find{|a| a.spotify_id == spotify_track.id}
      if spotify_track.present? and track.present?
        track.update_attributes(audio_features: {
          acousticness: spotify_track.acousticness,
          danceability: spotify_track.danceability,
          energy: spotify_track.energy,
          instrumentalness: spotify_track.instrumentalness,
          key: spotify_track.key,
          liveness: spotify_track.liveness,
          loudness: spotify_track.loudness,
          mode: spotify_track.mode,
          speechiness: spotify_track.speechiness,
          tempo: spotify_track.tempo,
          time_signature: spotify_track.time_signature,
          valence: spotify_track.valence
        }, audio_features_last_checked: Time.now)
      elsif track.present?
        track.touch(:audio_features_last_checked)
      end
    end
    
  end
end
