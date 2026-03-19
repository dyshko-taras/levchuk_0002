import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { useAppContext } from '../context/AppContext';

const durations = [1, 3, 5, 10];
const modes = ['Calm', 'Energy', 'Focus'];

export function BreathingSettingsScreen() {
  const navigate = useNavigate();
  const { breathDuration, setBreathDuration, breathMode, setBreathMode, breathSound, setBreathSound } = useAppContext();

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px' }}>
        {/* Header */}
        <div
          onClick={() => { navDir.back(); navigate('/breathe'); }}
          style={{ cursor: 'pointer', fontSize: 14, color: '#fff', marginBottom: 4, padding: '8px 12px 8px 0', marginLeft: -2, display: 'inline-block', minHeight: 36, lineHeight: '20px' }}
        >
          ◄ Back
        </div>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Settings Panel
        </h1>

        {/* Duration */}
        <div style={{ marginTop: 24 }}>
          <div style={{ fontSize: 14, color: 'var(--text-gray)', marginBottom: 8 }}>Duration, (min):</div>
          <div style={{ display: 'flex', gap: 8 }}>
            {durations.map((d) => (
              <button
                key={d}
                onClick={() => setBreathDuration(d)}
                style={{
                  flex: 1,
                  padding: '14px 0',
                  borderRadius: 10,
                  border: 'none',
                  fontSize: 16,
                  fontWeight: breathDuration === d ? 700 : 400,
                  background: breathDuration === d ? '#35b769' : '#151b29',
                  color: breathDuration === d ? '#fff' : 'var(--text-gray)',
                  cursor: 'pointer',
                }}
              >
                {d}
              </button>
            ))}
          </div>
        </div>

        {/* Mode */}
        <div style={{ marginTop: 24 }}>
          <div style={{ fontSize: 14, color: 'var(--text-gray)', marginBottom: 8 }}>Mode:</div>
          <div style={{ display: 'flex', gap: 8 }}>
            {modes.map((m) => (
              <button
                key={m}
                onClick={() => setBreathMode(m)}
                style={{
                  flex: 1,
                  padding: '14px 0',
                  borderRadius: 10,
                  border: 'none',
                  fontSize: 14,
                  fontWeight: breathMode === m ? 700 : 400,
                  background: breathMode === m ? '#35b769' : '#151b29',
                  color: breathMode === m ? '#fff' : 'var(--text-gray)',
                  cursor: 'pointer',
                }}
              >
                {m}
              </button>
            ))}
          </div>
        </div>

        {/* Sound Toggle */}
        <div className="settings-row" style={{ marginTop: 24 }}>
          <span style={{ fontSize: 14, color: '#fff' }}>Sound:</span>
          <div className="toggle-track" onClick={() => setBreathSound(!breathSound)}>
            <div style={{
              width: 20,
              height: 20,
              borderRadius: 9999,
              position: 'absolute',
              top: 2,
              left: breathSound ? 22 : 2,
              background: breathSound ? '#1ea155' : '#9e9e9e',
              transition: 'left 0.2s, background 0.2s',
            }} />
          </div>
        </div>
        <div style={{ height: 20 }} />
      </div>
      <BottomNav active={2} />
    </>
  );
}
