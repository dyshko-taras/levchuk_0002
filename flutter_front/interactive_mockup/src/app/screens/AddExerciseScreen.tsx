import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';

const exercises = [
  { selected: true, emoji: '📋', name: 'Stand Side Bend', duration: '00:25' },
  { selected: false, emoji: '🏃', name: 'Chair Squat', duration: '00:30' },
  { selected: true, emoji: '💪', name: 'Shoulder Rolls', duration: '00:20' },
];

export function AddExerciseScreen() {
  const navigate = useNavigate();

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px', display: 'flex', flexDirection: 'column' }}>
        {/* Header */}
        <div
          onClick={() => { navDir.back(); navigate('/workout'); }}
          style={{ cursor: 'pointer', fontSize: 14, color: '#fff', marginBottom: 4, padding: '8px 12px 8px 0', marginLeft: -2, display: 'inline-block', minHeight: 36, lineHeight: '20px' }}
        >
          ◄ Back
        </div>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Add Exercise
        </h1>

        {/* Search */}
        <input
          type="text"
          placeholder="🔍 Search exercises..."
          readOnly
          style={{
            width: '100%',
            marginTop: 16,
            padding: '12px 16px',
            borderRadius: 12,
            border: 'none',
            background: 'var(--dark-card)',
            color: '#fff',
            fontSize: 14,
            fontFamily: "'Open Sans', sans-serif",
            outline: 'none',
          }}
        />

        {/* Exercise List */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginTop: 16 }}>
          {exercises.map((ex) => (
            <div className="list-item" key={ex.name}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                {/* Selection indicator */}
                <div style={{
                  width: 28,
                  height: 28,
                  borderRadius: '50%',
                  border: ex.selected ? 'none' : '2px solid var(--green-start)',
                  background: ex.selected ? 'var(--green-start)' : 'transparent',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: 12,
                  color: '#fff',
                  flexShrink: 0,
                }}>
                  {ex.selected && '✓'}
                </div>
                <span style={{ fontSize: 14, color: '#fff' }}>
                  {ex.emoji} {ex.name}
                </span>
              </div>
              <span style={{ color: 'var(--green-start)', fontSize: 14 }}>
                {ex.duration}
              </span>
            </div>
          ))}
        </div>

        <div style={{ flex: 1 }} />
        {/* Action Buttons */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginTop: 24 }}>
          <button
            className="btn-green"
            onClick={() => { navDir.back(); navigate('/workout'); }}
          >
            Add Selected
          </button>
          <button
            className="btn-green-outline"
            onClick={() => { navDir.forward(); navigate('/workout/custom-step'); }}
          >
            + Custom Step
          </button>
        </div>
        <div style={{ height: 20 }} />
      </div>

      <BottomNav active={4} />
    </>
  );
}
