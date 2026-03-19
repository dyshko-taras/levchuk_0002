import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';

const routineData = [
  { label: '1st Hour', exercise: 'Stand Side Bend', status: '✅' },
  { label: '2nd Hour', exercise: 'Neck Stretch', status: '✅' },
  { label: '3rd Hour', exercise: 'Chair Squat', status: '🕐' },
  { label: '4th Hour', exercise: 'Shoulder Rolls', status: '⏳' },
  { label: '5th Hour', exercise: 'Stand Side Bend', status: '✅' },
  { label: '6th Hour', exercise: 'Stand Side Bend', status: '✅' },
  { label: '7th Hour', exercise: 'Stand Side Bend', status: '✅' },
  { label: '8th Hour', exercise: 'Glute Squeeze', status: '⏳' },
];

export function HomeScreen() {
  const navigate = useNavigate();

  const go = (path: string) => {
    navDir.forward();
    navigate(path);
  };

  return (
    <>
      <div className="screen-content" style={{ padding: '20px' }}>
        {/* Hero banner */}
        <div style={{
          borderRadius: 16,
          overflow: 'hidden',
          height: 120,
          marginBottom: 16,
          backgroundImage: 'url(/images/home_hero.webp)',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        }} />
        {/* Header */}
        <div>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ fontSize: 26, fontWeight: 700, color: '#25aaf9' }}>
              ActiveOffice Daily Routine
            </span>
            <div style={{ padding: 8, margin: -8, cursor: 'pointer' }} onClick={() => go('/settings')}><span style={{ fontSize: 22 }}>⚙️</span></div>
          </div>
          <p style={{ fontSize: 13, color: 'var(--text-gray2)', marginTop: 2 }}>
            Stay balanced throughout your workday
          </p>
          <div className="accent-bar-blue" style={{ marginTop: 10 }} />
        </div>

        {/* Today's Progress */}
        <div className="gradient-card" style={{ marginTop: 20 }}>
          <div className="accent-bar-blue" style={{ position: 'absolute', top: 0, left: 0, right: 0, borderRadius: 0 }} />
          <div style={{ fontSize: 16, fontWeight: 700, color: '#fff', marginBottom: 12 }}>
            📅 Today's Progress
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <div className="list-item">
              <span style={{ fontSize: 14, color: '#fff' }}>✅ Completed Hours:</span>
              <span style={{ fontSize: 14, fontWeight: 700, color: '#35b769' }}>3 / 8</span>
            </div>
            <div className="list-item">
              <span style={{ fontSize: 14, color: '#fff' }}>🏃 Breathing:</span>
              <span style={{ fontSize: 14, fontWeight: 700, color: '#35b769' }}>9 min</span>
            </div>
            <div className="list-item">
              <span style={{ fontSize: 14, color: '#fff' }}>🔥 Streak:</span>
              <span style={{ fontSize: 14, fontWeight: 700, color: '#35b769' }}>5 days</span>
            </div>
          </div>
          <div style={{ textAlign: 'right', marginTop: 10 }}>
            <span style={{ fontSize: 13, color: '#25aaf9', cursor: 'pointer' }}>🔄 Reset Day</span>
          </div>
        </div>

        {/* Hourly Routine */}
        <div style={{ marginTop: 24 }}>
          <div style={{ fontSize: 18, fontWeight: 700, color: '#fff', marginBottom: 12 }}>
            🕐 Hourly Routine
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {routineData.map((item) => (
              <div
                key={item.label}
                className="list-item"
                style={{ cursor: 'pointer' }}
                onClick={() => go('/exercise')}
              >
                <span style={{ fontSize: 14, color: '#fff' }}>{item.label}</span>
                <span style={{ fontSize: 14, color: '#fff' }}>
                  {item.exercise} {item.status} ►
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Actions */}
        <div style={{ marginTop: 24 }}>
          <div style={{ fontSize: 18, fontWeight: 700, color: '#fff', marginBottom: 12 }}>
            ✨ Quick Actions
          </div>
          <div style={{ display: 'flex', gap: 12 }}>
            <div className="quick-action-card" onClick={() => go('/exercise')}>
              <span style={{ fontSize: 28 }}>🏃</span>
              <span style={{ fontSize: 14, fontWeight: 600, color: '#fff', textAlign: 'center' }}>Quick Stretch</span>
            </div>
            <div className="quick-action-card" onClick={() => go('/breathe')}>
              <span style={{ fontSize: 28 }}>🌬️</span>
              <span style={{ fontSize: 14, fontWeight: 600, color: '#fff', textAlign: 'center' }}>Open Breathe</span>
            </div>
            <div className="quick-action-card" onClick={() => go('/tips')}>
              <span style={{ fontSize: 28 }}>💡</span>
              <span style={{ fontSize: 14, fontWeight: 600, color: '#fff', textAlign: 'center' }}>Tips of the Day</span>
            </div>
          </div>
        </div>

        {/* Quote of the Day */}
        <div className="gradient-card" style={{ marginTop: 24 }}>
          <div className="accent-bar-purple" style={{ marginBottom: 12 }} />
          <div style={{ fontSize: 14, fontWeight: 600, color: '#fff', marginBottom: 8 }}>
            ✨ Quote of the Day:
          </div>
          <p style={{ fontSize: 14, color: '#fff', lineHeight: 1.5 }}>
            "Small steps every day add up to big results."
          </p>
          <p style={{ fontSize: 13, fontStyle: 'italic', color: '#b377fe', textAlign: 'right', marginTop: 8 }}>
            — Roben D.
          </p>
        </div>

        {/* Bottom spacer */}
        <div style={{ height: 20 }} />
      </div>
      <BottomNav active={0} />
    </>
  );
}
