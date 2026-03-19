import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { useAppContext } from '../context/AppContext';

const toggleRows = [
  { key: 'hourlyReminders', label: 'Hourly Reminders' },
  { key: 'breathingReminders', label: 'Breathing Reminders' },
  { key: 'sound', label: 'Sound' },
];

export function SettingsScreen() {
  const navigate = useNavigate();
  const { toggleStates, setToggle } = useAppContext();

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px' }}>
        {/* Header */}
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Settings
        </h1>

        {/* Toggle Rows */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginTop: 20 }}>
          {toggleRows.map(({ key, label }) => (
            <div key={key} className="settings-row">
              <span style={{ fontSize: 14, color: '#fff' }}>{label}</span>
              <div className="toggle-track" onClick={() => setToggle(key, !toggleStates[key])}>
                <div style={{
                  width: 20,
                  height: 20,
                  borderRadius: 9999,
                  position: 'absolute',
                  top: 2,
                  left: toggleStates[key] ? 22 : 2,
                  background: toggleStates[key] ? '#1ea155' : '#9e9e9e',
                  transition: 'left 0.2s, background 0.2s',
                }} />
              </div>
            </div>
          ))}
        </div>

        {/* Buttons */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginTop: 32 }}>
          <button className="btn-green-outline" style={{ width: '100%' }}>Support</button>
          <button className="btn-green-outline" style={{ width: '100%' }}>Privacy Policy</button>
          <button className="btn-red" style={{ width: '100%' }}>Reset Progress</button>
        </div>
        <div style={{ height: 20 }} />
      </div>
      <BottomNav active={5} />
    </>
  );
}
