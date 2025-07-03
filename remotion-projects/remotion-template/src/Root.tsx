import "./index.css";
import { Composition } from "remotion";
// IMPORTANT: Import helloWorldProps, not myCompSchema, as that's what we named it in HelloWorld.tsx
import { totalDuration, numberOfSequences, NewsVideo, newsCardProps } from "./NewsVideo";

// Each <Composition> is an entry in the sidebar!

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="NewsVideo"
        component={NewsVideo}
        durationInFrames={totalDuration * numberOfSequences}
        fps={30}
        width={1080}
        height={1920}
        // Link the correct schema
        schema={newsCardProps}
        // Now, define the defaultProps for your new headline and video source props
        defaultProps={{
          headline1:
            "Set in the mystical world of Etere, you play as Ghost—a spirit born from a lonely shooting star",
          headline2:
            "Set in the mystical world of Etere, you play as Ghost—a spirit born from a lonely shooting star",
          headline3:
            "Set in the mystical world of Etere, you play as Ghost—a spirit born from a lonely shooting star",
          video1Src: "download.mp4",
          video2Src: "download.mp4",
          video3Src: "download.mp4",
        }}
      />
    </>
  );
};
