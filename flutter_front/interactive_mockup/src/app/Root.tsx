import { Outlet } from 'react-router';

export function Root() {
  return (
    <div className="phone-frame">
      <Outlet />
    </div>
  );
}
