import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { ScreenHeader } from '../components/ScreenHeader';

const topics = [
  { img: '/images/tip_eye.webp', title: 'Eye Tips', desc: 'Reduce strain and protect your eyes during long hours in front of a screen' },
  { img: '/images/tip_posture.webp', title: 'Posture Tips', desc: 'Keep your body aligned and comfortable throughout the workday' },
  { img: '/images/tip_stress.webp', title: 'Stress Tips', desc: 'Calm your mind, manage daily pressure, and improve focus' },
  { img: '/images/tip_focus.webp', title: 'Focus & Fatigue', desc: 'Reignite concentration and maintain steady energy throughout the day' },
  { img: '/images/tip_hydration.webp', title: 'Hydration & Nutrition', desc: 'Fuel your body with hydration and simple, energizing meals' },
  { img: '/images/tip_sleep.webp', title: 'Sleep & Recovery', desc: 'Rest deeply to recharge your mind and body' },
  { img: '/images/tip_mental.webp', title: 'Mental Health', desc: 'Build emotional balance and resilience against daily stress' },
  { img: '/images/tip_mobility.webp', title: 'Mobility & Stretching', desc: 'Stay flexible and prevent stiffness caused by prolonged sitting' },
  { img: '/images/tip_productivity.webp', title: 'Productivity & Time Balance', desc: 'Work smarter, not longer — balance focus and rest' },
  { img: '/images/tip_breathing.webp', title: 'Breathing & Relaxation', desc: 'Regain calm and focus through intentional breathing' },
];

export function WellnessTipsScreen() {
  const navigate = useNavigate();

  return (
    <>
      <div className="screen-content" style={{ padding: '0 20px 20px' }}>
        <ScreenHeader title="Wellness Tips" />

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginTop: 16 }}>
          {topics.map((t) => (
            <div
              key={t.title}
              className="gradient-card"
              style={{ cursor: 'pointer', position: 'relative', overflow: 'hidden', display: 'flex', gap: 12, alignItems: 'center' }}
              onClick={() => { navDir.forward(); navigate('/tips/eye'); }}
            >
              <div className="accent-bar-blue" style={{ position: 'absolute', bottom: 0, left: 0, right: 0, borderRadius: 0 }} />
              {t.img ? (
                <img src={t.img} alt={t.title} style={{ width: 56, height: 56, borderRadius: 12, objectFit: 'cover', flexShrink: 0 }} />
              ) : (
                <div style={{ width: 56, height: 56, borderRadius: 12, background: 'rgba(30,190,240,0.15)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 28, flexShrink: 0 }}>
                  {(t as any).emoji}
                </div>
              )}
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 16, fontWeight: 700, color: '#fff' }}>
                  {t.title}
                </div>
                <div style={{ fontSize: 13, color: 'var(--text-gray)', marginTop: 4 }}>
                  {t.desc}
                </div>
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
