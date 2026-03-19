import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';

const tips = [
  {
    title: 'The 20-20-20 Rule',
    body: 'Every 20 minutes, look at an object 20 feet away for at least 20 seconds. This simple practice relaxes the tiny muscles responsible for focus and helps prevent digital eye strain. Pair it with slow blinking to keep your eyes moist and refreshed.',
  },
  {
    title: 'Adjust Your Lighting',
    body: 'Avoid bright overhead lights and heavy glare on your screen. Soft, indirect light or a desk lamp on the opposite side of your dominant hand works best. Proper lighting reduces tension in your eyes and improves concentration.',
  },
  {
    title: 'Keep Screens at Eye Level',
    body: 'Position your monitor so the top of the screen is at or slightly below eye level. This keeps your neck relaxed and your eyes in a natural downward angle. This minimizes fatigue during extended work sessions.',
  },
];

export function TipDetailScreen() {
  const navigate = useNavigate();

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px' }}>
        {/* Header */}
        <div
          onClick={() => { navDir.back(); navigate('/tips'); }}
          style={{ cursor: 'pointer', fontSize: 14, color: '#fff', marginBottom: 4, padding: '8px 12px 8px 0', marginLeft: -2, display: 'inline-block', minHeight: 36, lineHeight: '20px' }}
        >
          ◄ Back
        </div>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Eye Tips
        </h1>
        <div className="accent-bar-blue" style={{ marginTop: 10 }} />

        {/* Hero illustration */}
        <div style={{
          marginTop: 16,
          borderRadius: 16,
          overflow: 'hidden',
          height: 160,
          backgroundImage: 'url(/images/tip_eye.webp)',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        }} />

        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginTop: 16 }}>
          {tips.map((tip) => (
            <div key={tip.title} className="gradient-card">
              <div style={{ fontSize: 15, fontWeight: 700, color: '#fff' }}>{tip.title}</div>
              <div style={{ fontSize: 13, color: 'var(--text-gray)', marginTop: 6, lineHeight: 1.5 }}>
                {tip.body}
              </div>
            </div>
          ))}
        </div>
        <div style={{ height: 20 }} />
      </div>
      <BottomNav active={1} />
    </>
  );
}
