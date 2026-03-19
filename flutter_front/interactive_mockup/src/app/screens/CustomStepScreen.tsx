import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';

export function CustomStepScreen() {
  const navigate = useNavigate();

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px', display: 'flex', flexDirection: 'column' }}>
        {/* Header */}
        <div
          onClick={() => { navDir.back(); navigate('/workout/add'); }}
          style={{ cursor: 'pointer', fontSize: 14, color: '#fff', marginBottom: 4, padding: '8px 12px 8px 0', marginLeft: -2, display: 'inline-block', minHeight: 36, lineHeight: '20px' }}
        >
          ◄ Back
        </div>
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Custom Step
        </h1>

        {/* Name Field */}
        <div style={{ marginTop: 24 }}>
          <label style={{ fontSize: 14, color: 'var(--text-gray)', display: 'block', marginBottom: 6 }}>
            Name:
          </label>
          <input
            type="text"
            defaultValue="Stand Side Bend"
            readOnly
            style={{
              width: '100%',
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
        </div>

        {/* Duration Field */}
        <div style={{ marginTop: 16 }}>
          <label style={{ fontSize: 14, color: 'var(--text-gray)', display: 'block', marginBottom: 6 }}>
            Duration:
          </label>
          <input
            type="text"
            defaultValue="00:25"
            readOnly
            style={{
              width: '100%',
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
        </div>

        {/* Bottom Button */}
        <div style={{ flex: 1 }} />
        <button
          className="btn-green"
          style={{ marginTop: 32 }}
          onClick={() => { navDir.back(); navigate('/workout'); }}
        >
          ✅ Add to Routine
        </button>
        <div style={{ height: 20 }} />
      </div>

      <BottomNav active={4} />
    </>
  );
}
