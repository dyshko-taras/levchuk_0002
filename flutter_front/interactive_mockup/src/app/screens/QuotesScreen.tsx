import { useNavigate } from 'react-router';
import { navDir } from '../navDir';
import { BottomNav } from '../components/BottomNav';
import { useAppContext } from '../context/AppContext';

const quotes: [string, string][] = [
  ['Small steps every day add up to big results.', 'Unknown'],
  ["Your body can stand almost anything. It's your mind you have to convince.", 'Anonymous'],
  ["You don't have to be extreme, just consistent.", 'Unknown'],
];

export function QuotesScreen() {
  const navigate = useNavigate();
  const { currentQuoteIndex, setCurrentQuoteIndex } = useAppContext();

  const [text, author] = quotes[currentQuoteIndex];

  return (
    <>
      <div className="screen-content" style={{ padding: '16px 20px 24px', position: 'relative' }}>
        {/* Background image */}
        <div style={{
          position: 'absolute',
          inset: 0,
          backgroundImage: 'url(/images/quotes_bg.webp)',
          backgroundSize: 'cover',
          backgroundPosition: 'center top',
          opacity: 0.15,
          pointerEvents: 'none',
        }} />
        {/* Header */}
        <h1 style={{ fontSize: 26, fontWeight: 700, color: 'var(--primary-blue)', lineHeight: 1.2 }}>
          Inspiring Quotes
        </h1>
        <div className="accent-bar-purple" style={{ marginTop: 10 }} />

        {/* Quote Card */}
        <div className="gradient-card" style={{ marginTop: 20, position: 'relative', overflow: 'hidden' }}>
          <div className="accent-bar-purple" style={{ position: 'absolute', top: 0, left: 0, right: 0, borderRadius: 0 }} />
          <div style={{ fontSize: 15, fontWeight: 700, color: '#fff', marginTop: 4 }}>
            ✨ Quote of the Day:
          </div>
          <p style={{ fontSize: 16, color: '#fff', lineHeight: 1.5, marginTop: 10 }}>
            "{text}"
          </p>
          <p style={{ fontSize: 13, fontStyle: 'italic', color: '#b377fe', textAlign: 'right', marginTop: 10 }}>
            — {author}
          </p>
        </div>

        {/* Spacer */}
        <div style={{ flex: 1, minHeight: 80 }} />

        {/* Buttons */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <button className="btn-green-outline" style={{ width: '100%' }}>Past quotes</button>
          <button
            className="btn-green"
            style={{ width: '100%' }}
            onClick={() => setCurrentQuoteIndex((currentQuoteIndex + 1) % 3)}
          >
            Next Quote
          </button>
        </div>
        <div style={{ height: 20 }} />
      </div>
      <BottomNav active={3} />
    </>
  );
}
