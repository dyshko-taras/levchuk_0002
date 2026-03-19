import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { useAppContext } from '../context/AppContext';

export function ExerciseScreen() {
  const navigate = useNavigate();
  const { showExerciseComplete, setShowExerciseComplete } = useAppContext();

  const circumference = 2 * Math.PI * 126;
  const progress = 0.7;

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px' }}>
        {/* Header */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div
            onClick={() => { navDir.back(); navigate('/home'); }}
            style={{ cursor: 'pointer', fontSize: 14, color: '#fff', padding: '8px 12px 8px 0', marginLeft: -2, display: 'inline-block', minHeight: 36, lineHeight: '20px' }}
          >
            ◄ Back
          </div>
          <span style={{ fontSize: 22, cursor: 'pointer', padding: 6, margin: -6 }}>💬</span>
        </div>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2, marginTop: 4 }}>
          Stay Active at Work
        </h1>
        <p style={{ fontSize: 13, color: 'var(--text-gray2)', marginTop: 2 }}>
          Hourly stretches to refresh your body and boost focus
        </p>
        <div className="accent-bar-blue" style={{ marginTop: 10 }} />

        {/* Exercise Card */}
        <div className="gradient-card" style={{ marginTop: 16 }}>
          <div style={{ fontSize: 16, fontWeight: 700, color: '#fff' }}>📋 Stand Side Bend</div>
          <div style={{ fontSize: 13, color: 'var(--text-gray)', marginTop: 6 }}>
            🫧 Motivation: Loosen up your spine and breathe deeply.
          </div>
          <div style={{
            background: 'rgba(0,0,0,0.25)',
            borderRadius: 10,
            padding: 12,
            marginTop: 10,
          }}>
            <p style={{ fontSize: 13, color: 'var(--text-muted)' }}>
              Stand straight, place one hand on your hip, and bend sideways slowly. Alternate sides.
            </p>
          </div>
        </div>

        {/* Circular Timer */}
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginTop: 24 }}>
          <svg width={280} height={280} style={{ transform: 'rotate(-90deg)' }}>
            <circle
              cx={140} cy={140} r={126}
              fill="none"
              stroke="rgba(255,255,255,0.08)"
              strokeWidth={10}
            />
            <circle
              cx={140} cy={140} r={126}
              fill="none"
              stroke="url(#purpleGrad)"
              strokeWidth={10}
              strokeLinecap="round"
              strokeDasharray={circumference}
              strokeDashoffset={circumference * (1 - progress)}
            />
            <defs>
              <linearGradient id="purpleGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" stopColor="#b57aff" />
                <stop offset="100%" stopColor="#8f33ea" />
              </linearGradient>
            </defs>
          </svg>
          <div style={{
            position: 'relative',
            marginTop: -180,
            marginBottom: 90,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}>
            <span style={{ fontSize: 56, fontWeight: 700, color: '#fff' }}>00:25</span>
            <span style={{ fontSize: 20, color: 'var(--text-gray)', marginTop: 4 }}>Let's go</span>
          </div>
        </div>

        {/* Controls */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginTop: 8 }}>
          <button className="btn-circle">⏮</button>
          <button
            className="btn-red"
            style={{ flex: 1 }}
            onClick={() => setShowExerciseComplete(true)}
          >
            Stop
          </button>
          <button className="btn-circle">⏭</button>
        </div>

        {/* Hour Info */}
        <div className="gradient-card" style={{ marginTop: 20, position: 'relative', overflow: 'hidden', paddingTop: 20 }}>
          <div className="accent-bar-purple" style={{ position: 'absolute', top: 0, left: 0, right: 0, borderRadius: 0 }} />
          <div style={{ fontSize: 14, color: 'var(--text-gray)', marginTop: 4 }}>🕐 Hour:</div>
          <div style={{ fontSize: 15, fontWeight: 600, color: '#fff', marginTop: 4 }}>
            3rd Hour — Midday Focus
          </div>
          <div style={{ fontSize: 13, color: 'var(--green-start)', marginTop: 6 }}>
            📈 Streak continues!
          </div>
        </div>

        {/* Bottom spacer */}
        <div style={{ height: 20 }} />
      </div>

      <BottomNav active={0} />

      {/* Completion Popup */}
      {showExerciseComplete && (
        <div className="modal-overlay">
          <div className="modal-card">
            <div style={{ fontSize: 28, marginBottom: 8 }}>🎉</div>
            <h2 style={{ fontSize: 20, fontWeight: 700, marginBottom: 8 }}>Session Complete</h2>
            <p style={{ fontSize: 14, color: '#555', marginBottom: 20 }}>
              You've completed your hourly exercise! Time for a short water break.
            </p>
            <div style={{ display: 'flex', gap: 12 }}>
              <button
                className="btn-green"
                style={{ flex: 1 }}
                onClick={() => {
                  setShowExerciseComplete(false);
                  navDir.back();
                  navigate('/home');
                }}
              >
                Done
              </button>
              <button
                className="btn-green-outline"
                style={{ flex: 1, color: '#1b9e52' }}
                onClick={() => setShowExerciseComplete(false)}
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
