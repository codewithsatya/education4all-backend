import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { Play, Upload, Trash2, Plus } from 'lucide-react';

interface Video {
  id: string;
  title: string;
  description: string;
  url: string;
}

export function TutorDashboard() {
  const [videos, setVideos] = useState<Video[]>([]);
  const [loading, setLoading] = useState(true);
  const [isUploading, setIsUploading] = useState(false);
  const [newVideo, setNewVideo] = useState({
    title: '',
    description: '',
    url: ''
  });

  useEffect(() => {
    fetchVideos();
  }, []);

  async function fetchVideos() {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      const { data, error } = await supabase
        .from('videos')
        .select('*')
        .eq('tutor_id', user.id)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setVideos(data || []);
    } catch (error) {
      console.error('Error fetching videos:', error);
    } finally {
      setLoading(false);
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setIsUploading(true);

    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) throw new Error('No user found');

      const { error } = await supabase.from('videos').insert({
        ...newVideo,
        tutor_id: user.id
      });

      if (error) throw error;

      setNewVideo({ title: '', description: '', url: '' });
      fetchVideos();
    } catch (error) {
      console.error('Error uploading video:', error);
    } finally {
      setIsUploading(false);
    }
  }

  async function handleDelete(videoId: string) {
    if (!confirm('Are you sure you want to delete this video?')) return;

    try {
      const { error } = await supabase
        .from('videos')
        .delete()
        .eq('id', videoId);

      if (error) throw error;
      fetchVideos();
    } catch (error) {
      console.error('Error deleting video:', error);
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  return (
    <div>
      <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow-lg p-6 mb-8">
        <h3 className="text-lg font-semibold text-gray-800 mb-4 flex items-center">
          <Plus className="w-5 h-5 mr-2" />
          Add New Video
        </h3>
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Video Title
            </label>
            <input
              type="text"
              value={newVideo.title}
              onChange={(e) => setNewVideo({ ...newVideo, title: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Description
            </label>
            <textarea
              value={newVideo.description}
              onChange={(e) => setNewVideo({ ...newVideo, description: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
              rows={3}
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Video URL
            </label>
            <input
              type="url"
              value={newVideo.url}
              onChange={(e) => setNewVideo({ ...newVideo, url: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
              required
              placeholder="https://example.com/video"
            />
          </div>
          <button
            type="submit"
            disabled={isUploading}
            className="w-full bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:opacity-50 flex items-center justify-center"
          >
            {isUploading ? (
              <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
            ) : (
              <>
                <Upload className="w-4 h-4 mr-2" />
                Add Video
              </>
            )}
          </button>
        </div>
      </form>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {videos.map((video) => (
          <div key={video.id} className="bg-white rounded-lg shadow-lg overflow-hidden">
            <div className="aspect-video bg-gray-100 flex items-center justify-center">
              <Play className="w-12 h-12 text-blue-500" />
            </div>
            <div className="p-4">
              <h3 className="text-lg font-semibold text-gray-800 mb-2">{video.title}</h3>
              <p className="text-gray-600 text-sm">{video.description}</p>
              <div className="mt-4 flex justify-between items-center">
                <a
                  href={video.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center text-blue-500 hover:text-blue-700"
                >
                  Watch Video
                  <Play className="w-4 h-4 ml-1" />
                </a>
                <button
                  onClick={() => handleDelete(video.id)}
                  className="text-red-500 hover:text-red-700"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        ))}
        {videos.length === 0 && (
          <div className="col-span-full text-center py-12">
            <h3 className="text-lg font-medium text-gray-600">No videos uploaded yet</h3>
            <p className="text-gray-500 mt-2">Start by adding your first video above</p>
          </div>
        )}
      </div>
    </div>
  );
}