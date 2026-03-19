import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { ScreenHeader } from '../components/ScreenHeader';

const exercises = [
  { num: '01', name: 'Stand Side Be...', duration: '00:25' },
  { num: '02', name: 'Chair Squ...', duration: '00:30' },
  { num: '03', name: 'Neck Stretch', duration: '00:20' },
];

export function CustomWorkoutScreen() {
  const navigate = useNavigate();

  return (
    <>
      <div className="screen-content">
        <ScreenHeader
          title="Create Workout"
          subtitle="Build your personalized desk routine"
        />

        {/* Hero illustration */}
        <div style={{
          margin: '0 20px',
          borderRadius: 16,
          overflow: 'hidden',
          height: 140,
          backgroundImage: 'url(/images/workout_hero.webp)',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        }} />

        <div style={{ padding: '0 20px 24px' }}>
          {/* Routine Card */}
          <div className="gradient-card" style={{ marginTop: 16 }}>
            <div style={{ fontSize: 16, fontWeight: 700, color: '#fff', marginBottom: 12 }}>
              📋 Current Routine:
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {exercises.map((ex) => (
                <div className="list-item" key={ex.num}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                    <span style={{ fontWeight: 700, color: 'var(--green-start)', fontSize: 15 }}>{ex.num}</span>
                    <span style={{ color: '#fff', fontSize: 14 }}>{ex.name}</span>
                  </div>
                  <span style={{ color: 'var(--green-start)', fontSize: 14 }}>{ex.duration}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Add Exercise */}
          <button
            className="btn-dashed"
            style={{ marginTop: 16 }}
            onClick={() => { navDir.forward(); navigate('/workout/add'); }}
          >
            + Add Exercise
          </button>

          {/* Bottom Buttons */}
          <div style={{ marginTop: 32, display: 'flex', flexDirection: 'column', gap: 12 }}>
            <button className="btn-green-outline">💾 Save Routine</button>
            <button
              className="btn-green"
              onClick={() => { navDir.forward(); navigate('/exercise'); }}
            >
              ▶ Start Routine
            </button>
          </div>
          <div style={{ height: 20 }} />
        </div>
      </div>

      <BottomNav active={4} />
    </>
  );
}
