import "./index.css";
import { Composition } from "remotion";
// IMPORTANT: Import helloWorldProps, not myCompSchema, as that's what we named it in HelloWorld.tsx
import { NewsVideo, newsCardProps } from "./NewsVideo";


// Each <Composition> is an entry in the sidebar!

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="NewsVideo"
        component={NewsVideo}
        // Ensure durationInFrames is long enough for your content (e.g., 2 sequences * 120 frames = 240 frames minimum)
        durationInFrames={360}
        fps={30}
        width={1080}
        height={1920}
        // Link the correct schema
        schema={newsCardProps}
        // Now, define the defaultProps for your new headline and video source props
        defaultProps={{
          headline1: "Breaking News: Global AI Summit Concludes with Major Breakthroughs!",
          headline2: "Future of Tech: New Quantum Computing Method Unveiled.",
          headline3: "The last headling",
          // IMPORTANT: Replace these with valid, publicly accessible video URLs or staticFile paths if local
          video1Src: "https://remotion.dev/external/example-video-1.mp4",
          video2Src: "https://remotion.dev/external/example-video-2.mp4",
	  video3Src: "https://remotion.dev/external/example-video-2.mp4",
        }}
      />
    </>
  );
};
