import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { Play } from 'lucide-react';

interface Video {
  id: string;
  title: string;
  description: string;
  url: string;
  tutor_id: string;
}

export function StudentDashboard() {
  const [videos, setVideos] = useState<Video[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchVideos();
  }, []);

  async function fetchVideos() {
    try {
      const { data, error } = await supabase
        .from('videos')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setVideos(data || []);
    } catch (error) {
      console.error('Error fetching videos:', error);
    } finally {
      setLoading(false);
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
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {videos.map((video) => (
        <div key={video.id} className="bg-white rounded-lg shadow-lg overflow-hidden">
          <div className="aspect-video bg-gray-100 flex items-center justify-center">
            <Play className="w-12 h-12 text-blue-500" />
          </div>
          <div className="p-4">
            <h3 className="text-lg font-semibold text-gray-800 mb-2">{video.title}</h3>
            <p className="text-gray-600 text-sm">{video.description}</p>
            <a
              href={video.url}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-4 inline-flex items-center text-blue-500 hover:text-blue-700"
            >
              Watch Video
              <Play className="w-4 h-4 ml-1" />
            </a>
          </div>
        </div>
      ))}
      {videos.length === 0 && (
        <div className="col-span-full text-center py-12">
          <h3 className="text-lg font-medium text-gray-600">No videos available yet</h3>
          <p className="text-gray-500 mt-2">Check back later for new content</p>
        </div>
      )}
    </div>
  );
}