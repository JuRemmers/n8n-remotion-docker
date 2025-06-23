import React from 'react';
import { staticFile } from 'remotion';
import { Composition } from 'remotion';
import { PagesComp, DataSchema } from './Pages';
import { MyComposition } from "./Composition";
import { CompSchema } from "./Composition";
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
      <Composition
        id="MyComp"
        component={MyComposition}
	schema={CompSchema}
	defaultProps={{
		headline: 'This is the headline',
		fontScale: 80,
		imgUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1280&q=80",
		}}
        durationInFrames={240}
        fps={30}
        width={1080}
        height={1920}
      />
	    
{/* News bumper composition */}
    <Composition
      id="NewsComp"                 // will show up as “NewsComp” in Remotion Studio
      component={NewsComposition}   // points to MyComposition inside News.tsx
      defaultProps={{ scenes: demoScenes }}
      durationInFrames={NEWS_DURATION}
      fps={30}
      width={1080}
      height={1920}
    />
  </>
);
