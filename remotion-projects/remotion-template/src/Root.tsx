import React from 'react';
import { Composition } from 'remotion';
import { PagesComp, DataSchema } from './Pages';
import { MyComposition } from "./Composition";
import { CompSchema } from "./Composition";



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
    </>
  );
};