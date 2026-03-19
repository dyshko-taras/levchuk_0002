import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { useAppContext } from '../context/AppContext';

export function BreathingScreen() {
  const navigate = useNavigate();
  const { breathingPhase, setBreathingPhase, showBreathingComplete, setShowBreathingComplete } = useAppContext();

  const isInhale = breathingPhase === 'inhale';
  const circleSize = isInhale ? 140 : 280;

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px', position: 'relative' }}>
        {/* Background image */}
        <div style={{
          position: 'absolute',
          inset: 0,
          backgroundImage: 'url(/images/breathing_bg.webp)',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          opacity: 0.25,
          pointerEvents: 'none',
        }} />
        {/* Header */}
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Focus Breathing
        </h1>
        <p style={{ fontSize: 13, color: 'var(--text-gray2)', marginTop: 2 }}>
          Relax your mind. Refocus your energy
        </p>

        {/* Timer */}
        <div style={{ textAlign: 'center', marginTop: 24 }}>
          <div style={{ fontSize: 56, fontWeight: 700, color: '#fff' }}>02:32</div>
          <div style={{ fontSize: 14, color: 'var(--text-gray)', marginTop: 4 }}>Cycle 2 of 5</div>
        </div>

        {/* Breathing Circle */}
        <div
          style={{
            width: 320,
            height: 320,
            margin: '24px auto',
            position: 'relative',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            cursor: 'pointer',
          }}
          onClick={() => setBreathingPhase(isInhale ? 'hold' : 'inhale')}
        >
          {/* Concentric rings */}
          <div style={{
            position: 'absolute',
            width: 320, height: 320, borderRadius: '50%',
            background: 'rgba(30, 190, 240, 0.06)',
          }} />
          <div style={{
            position: 'absolute',
            width: 270, height: 270, borderRadius: '50%',
            background: 'rgba(30, 190, 240, 0.1)',
          }} />
          <div style={{
            position: 'absolute',
            width: 220, height: 220, borderRadius: '50%',
            background: 'rgba(30, 190, 240, 0.15)',
          }} />
          <div style={{
            position: 'absolute',
            width: 170, height: 170, borderRadius: '50%',
            background: 'rgba(30, 190, 240, 0.2)',
          }} />

          {/* Center circle */}
          <div style={{
            width: circleSize,
            height: circleSize,
            borderRadius: '50%',
            background: 'linear-gradient(135deg, #8FE4FF, #1EBEF0)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            transition: 'all 0.5s ease',
            zIndex: 1,
          }}>
            <span style={{ fontSize: 18, fontWeight: 600, color: '#fff' }}>
              {isInhale ? 'Inhale...' : 'Hold...'}
            </span>
          </div>
        </div>

        {/* Controls */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginTop: 8 }}>
          <button
            className="btn-circle"
            onClick={() => { navDir.forward(); navigate('/breathe/settings'); }}
          >⚙️</button>
          <button
            className="btn-red"
            style={{ flex: 1 }}
            onClick={() => setShowBreathingComplete(true)}
          >
            Stop
          </button>
          <button className="btn-circle">🔄</button>
        </div>

        {/* Bottom spacer */}
        <div style={{ height: 20 }} />
      </div>

      <BottomNav active={2} />

      {/* Completion Modal */}
      {showBreathingComplete && (
        <div className="modal-overlay">
          <div className="modal-card">
            <div style={{ fontSize: 28, marginBottom: 8 }}>🎉</div>
            <h2 style={{ fontSize: 20, fontWeight: 700, marginBottom: 8 }}>Well done!</h2>
            <p style={{ fontSize: 14, color: '#555', marginBottom: 20 }}>
              You've completed your breathing session
            </p>
            <div style={{ display: 'flex', gap: 12 }}>
              <button
                className="btn-green"
                style={{ flex: 1 }}
                onClick={() => {
                  setShowBreathingComplete(false);
                  navDir.back();
                  navigate('/home');
                }}
              >
                Done
              </button>
              <button
                className="btn-green-outline"
                style={{ flex: 1, color: '#1b9e52' }}
                onClick={() => setShowBreathingComplete(false)}
              >
                Repeat
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
