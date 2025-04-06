import React, { useEffect, useState } from 'react';
import { AuthForm } from './components/AuthForm';
import { StudentDashboard } from './components/StudentDashboard';
import { TutorDashboard } from './components/TutorDashboard';
import { supabase } from './lib/supabase';
import { GraduationCap, LogOut } from 'lucide-react';

interface Profile {
  id: string;
  email: string;
  role: 'student' | 'tutor';
}

function App() {
  const [session, setSession] = useState<any>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      if (session) {
        fetchProfile(session.user.id);
      } else {
        setLoading(false);
      }
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (_event, session) => {
      setSession(session);
      if (session) {
        await fetchProfile(session.user.id);
      } else {
        setProfile(null);
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  async function fetchProfile(userId: string) {
    try {
      setError(null);
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();

      if (error) {
        if (error.code === 'PGRST116') {
          // Profile doesn't exist yet, wait a moment and retry
          await new Promise(resolve => setTimeout(resolve, 1000));
          return fetchProfile(userId);
        }
        throw error;
      }

      setProfile(data);
    } catch (error) {
      console.error('Error fetching profile:', error);
      setError('Unable to load profile. Please try signing out and back in.');
    } finally {
      setLoading(false);
    }
  }

  const handleSignOut = async () => {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {!session ? (
        <div className="min-h-screen flex flex-col items-center justify-center px-4">
          <div className="mb-8 flex items-center">
            <GraduationCap className="w-12 h-12 text-blue-500 mr-4" />
            <h1 className="text-4xl font-bold text-gray-800">EduPortal</h1>
          </div>
          <AuthForm onSuccess={() => {}} />
        </div>
      ) : (
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="flex justify-between items-center mb-8">
            <div className="flex items-center">
              <GraduationCap className="w-8 h-8 text-blue-500 mr-3" />
              <h1 className="text-2xl font-bold text-gray-800">EduPortal</h1>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600">
                Signed in as: <span className="font-medium">{profile?.email}</span>
              </span>
              <button
                onClick={handleSignOut}
                className="flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Sign Out
              </button>
            </div>
          </div>
          
          {error ? (
            <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
              <p className="text-red-700">{error}</p>
            </div>
          ) : (
            <div className="bg-white rounded-lg shadow-lg p-6">
              <h2 className="text-xl font-semibold text-gray-800 mb-6">
                {profile?.role === 'tutor' ? 'Tutor Dashboard' : 'Student Dashboard'}
              </h2>
              {profile?.role === 'tutor' ? (
                <TutorDashboard />
              ) : (
                <StudentDashboard />
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

export default App;