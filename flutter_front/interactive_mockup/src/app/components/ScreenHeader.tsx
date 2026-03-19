import { useNavigate } from 'react-router';
import { navDir } from '../navDir';

interface Props {
  title: string;
  subtitle?: string;
  showBack?: boolean;
  showGear?: boolean;
  backPath?: string;
  onGear?: () => void;
  rightIcon?: string;
  onRightIcon?: () => void;
  accentColor?: 'blue' | 'purple';
}

export function ScreenHeader({ title, subtitle, showBack, showGear, backPath, onGear, rightIcon, onRightIcon, accentColor = 'blue' }: Props) {
  const navigate = useNavigate();

  const handleBack = () => {
    navDir.back();
    if (backPath) navigate(backPath);
    else navigate(-1);
  };

  const handleGear = () => {
    if (onGear) onGear();
    else { navDir.forward(); navigate('/settings'); }
  };

  return (
    <div style={{ padding: '16px 20px 0' }}>
      {showBack && (
        <div
          onClick={handleBack}
          style={{
            cursor: 'pointer',
            fontSize: 14,
            color: '#fff',
            marginBottom: 4,
            padding: '8px 12px 8px 0',
            marginLeft: -2,
            display: 'inline-block',
            minHeight: 36,
            lineHeight: '20px',
          }}
        >
          ◄ Back
        </div>
      )}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          {title}
        </h1>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          {rightIcon && (
            <span
              onClick={onRightIcon}
              style={{ fontSize: 22, cursor: 'pointer', padding: 6, margin: -6 }}
            >
              {rightIcon}
            </span>
          )}
          {showGear && (
            <span
              onClick={handleGear}
              style={{ fontSize: 22, cursor: 'pointer', padding: 6, margin: -6 }}
            >
              ⚙️
            </span>
          )}
        </div>
      </div>
      {subtitle && (
        <p style={{ fontSize: 13, color: 'var(--text-gray2)', marginTop: 2 }}>{subtitle}</p>
      )}
      <div className={accentColor === 'purple' ? 'accent-bar-purple' : 'accent-bar-blue'} style={{ marginTop: 10 }} />
    </div>
  );
}
