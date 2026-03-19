import { useEffect } from 'react';
import { useNavigate } from 'react-router';
import { navDir } from '../navDir';

export function SplashScreen() {
  const navigate = useNavigate();

  useEffect(() => {
    const timer = setTimeout(() => {
      navDir.forward();
      navigate('/welcome');
    }, 2000);
    return () => clearTimeout(timer);
  }, [navigate]);

  const segments = Array.from({ length: 16 }, (_, i) => i);

  return (
    <div
      style={{
        background: '#090f1e',
        flex: 1,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <div style={{ fontSize: 40, fontWeight: 700, color: '#fff', marginBottom: 24 }}>
        Loading...
      </div>
      <div style={{ display: 'flex', gap: 4 }}>
        {segments.map((i) => (
          <div
            key={i}
            style={{
              width: 14,
              height: 20,
              borderRadius: 4,
              background: i < 7 ? '#25aaf9' : 'rgba(255,255,255,0.15)',
            }}
          />
        ))}
      </div>
    </div>
  );
}
