import React from 'react';
import { Composition, staticFile } from 'remotion';
import { MyComposition as NewsComposition } from './News';
import type { NewsSceneProps } from './News'; 

const demoScenes: NewsSceneProps[] = [
  {
    headlineText: 'Cyberpunk 2077: New Expansion Teased',
    videoSrc: staticFile('news/cyberpunk.mp4'),
  },
  {
    headlineText: 'Valve Unveils Steam Deck 2 Dev Kit',
    videoSrc: staticFile('news/steam-deck-2.mp4'),
  },
];

// Each scene = 10 s  →  10 s × 2 scenes × 30 fps = 600 frames
const NEWS_DURATION = demoScenes.length * 10 * 30;

export const RemotionRoot: React.FC = () => {
  return (
    <>
      {/* News bumper composition */}
      <Composition
        id="News"
        component={NewsComposition}
        defaultProps={{ scenes: demoScenes }}
        durationInFrames={NEWS_DURATION}
        fps={30}
        width={1080}
        height={1920}
      />
    </>
  );
};
