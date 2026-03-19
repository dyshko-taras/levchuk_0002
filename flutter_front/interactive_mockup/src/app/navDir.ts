let _dir: 'forward' | 'back' = 'forward';

export const navDir = {
  get: (): 'forward' | 'back' => _dir,
  forward: () => { _dir = 'forward'; },
  back: () => { _dir = 'back'; },
};
