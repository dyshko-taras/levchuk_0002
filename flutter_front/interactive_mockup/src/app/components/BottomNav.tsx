import { useNavigate } from 'react-router';
import { navDir } from '../navDir';

const tabs = [
  { emoji: '🏠', label: 'Home', path: '/home' },
  { emoji: '💡', label: 'Tips', path: '/tips' },
  { emoji: '🌬️', label: 'Breathe', path: '/breathe' },
  { emoji: '🏆', label: 'Quotes', path: '/quotes' },
  { emoji: '🧘', label: 'Workout', path: '/workout' },
  { emoji: '⚙️', label: 'Settings', path: '/settings' },
];

export function BottomNav({ active }: { active: number }) {
  const navigate = useNavigate();

  return (
    <div style={{
      background: 'var(--nav-bg)',
      padding: '6px 0 10px',
      display: 'flex',
      justifyContent: 'space-around',
      flexShrink: 0,
    }}>
      {tabs.map((tab, i) => (
        <div
          key={tab.label}
          onClick={() => { navDir.forward(); navigate(tab.path); }}
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 2,
            cursor: 'pointer',
            position: 'relative',
            minWidth: 56,
            minHeight: 44,
            padding: '4px 4px 0',
          }}
        >
          {active === i && (
            <div style={{
              position: 'absolute',
              top: -6,
              width: 36,
              height: 6,
              borderRadius: '6px 6px 0 0',
              background: 'linear-gradient(to right, var(--nav-active-start), var(--nav-active-end))',
            }} />
          )}
          <span style={{ fontSize: 18, lineHeight: 1 }}>{tab.emoji}</span>
          <span style={{
            fontSize: 11,
            fontFamily: "'Rubik', sans-serif",
            color: '#fff',
            fontWeight: active === i ? 600 : 400,
          }}>{tab.label}</span>
        </div>
      ))}
    </div>
  );
}
