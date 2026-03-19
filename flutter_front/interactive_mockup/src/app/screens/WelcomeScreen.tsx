import { useNavigate } from 'react-router';
import { navDir } from '../navDir';

export function WelcomeScreen() {
  const navigate = useNavigate();
  return (
    <div style={{
      height: '100%',
      display: 'flex',
      flexDirection: 'column',
      background: 'var(--bg)',
      position: 'relative',
      overflow: 'hidden',
    }}>
      {/* Background illustration */}
      <div style={{
        position: 'absolute',
        inset: 0,
        backgroundImage: 'url(/images/welcome_hero.webp)',
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        opacity: 0.6,
      }} />
      <div style={{
        position: 'absolute',
        inset: 0,
        background: 'linear-gradient(to bottom, rgba(15,23,42,0.7) 0%, rgba(15,23,42,0.3) 40%, rgba(15,23,42,0.85) 75%, rgba(15,23,42,1) 100%)',
      }} />

      {/* Content */}
      <div style={{ position: 'relative', zIndex: 1, flex: 1, display: 'flex', flexDirection: 'column', padding: '60px 28px 40px' }}>
        <div>
          <div style={{ fontSize: 36, fontWeight: 700, fontStyle: 'italic', color: '#25aaf9', lineHeight: 1.2 }}>
            Discover ActiveOffice:
          </div>
          <div style={{ fontSize: 36, fontWeight: 700, color: '#fff', lineHeight: 1.2, marginTop: 4 }}>
            Your Partner for
          </div>
          <div style={{ fontSize: 36, fontWeight: 700, color: '#fff', lineHeight: 1.2, marginTop: 4 }}>
            Active Office Hours
          </div>
          <p style={{ fontSize: 15, color: 'var(--text-gray)', marginTop: 16, lineHeight: 1.5 }}>
            Hourly stretches, wellness tips, and inspiration — all in one place
          </p>
        </div>

        <div style={{ flex: 1 }} />

        <button className="btn-green" onClick={() => { navDir.forward(); navigate('/home'); }}>
          Get Started
        </button>
      </div>
    </div>
  );
}
