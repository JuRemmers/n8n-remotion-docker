import { spring } from "remotion";
import {
  AbsoluteFill,
  interpolate,
  Sequence,
  useCurrentFrame,
  useVideoConfig,
  OffthreadVideo,
  staticFile,
  Audio,
} from "remotion";
import { z } from "zod";
import { zColor } from "@remotion/zod-types";
import { useRef, useLayoutEffect, useState } from "react";

// --- START: Styles ---

export const newsCardStyles = {
  newsCard: {
    position: 'absolute',
    top: 200,
    left: '15%',
    width: '70%',
    overflow: 'hidden',
	zIndex: 1,
  },
  newsHeader: {
    borderWidth: '10px',
    borderStyle: 'none',
    borderTopStyle: 'double',
    borderBottomStyle: 'double',
    borderColor: '#B39649',
    textAlign: 'center',
    background: 'linear-gradient(90deg,rgba(84, 71, 41, 0) 0%, rgba(74, 41, 84, 1) 15%, rgba(74, 41, 84, 1) 85%, rgba(84, 71, 41, 0) 100%)',
    color: 'white',
    padding: ' 20px 60px 20px 60px',
    fontSize: 20,
    display: 'flex',
    flexDirection: 'column',
    gap: 20,
  },
  breaking: {
    color: 'white',
    fontWeight: 'bold',
    padding: '10px 10px',
    borderRadius: 10,
    display: 'inline-block',
    fontSize: 24,
	lineHeight: 0,
  },
  headline: {
    fontWeight: 'bold',
    fontSize: 40,
    textWrap: 'wrap',
  },
};

// --- END: Styles ---

// --- START: Props Schema ---

export const newsCardProps = z.object({
  headline1: z.string().default("Default Headline for First Sequence"),
  headline2: z.string().default("Default Headline for Second Sequence"),
  headline3: z.string().default("Default Headline for Third Sequence"),

  // These are local file names, so no need for z.string().url()
  video1Src: z.string().default("video1.mp4"),
  video2Src: z.string().default("video2.mp4"),
  video3Src: z.string().default("video3.mp4"),
});

// --- END: Props Schema ---

// --- START: Animated Card ---

interface NewsCardAnimatedProps {
  headlineText: string;
}

	const introDuration = 5 ;  // frames for height growing
	const outroDuration = 5;  // frames for height shrinking
	export const totalDuration = 120; // total duration of sequence (same as Sequence duration)
	export const numberOfSequences = 3  ; 

export const NewsCardAnimated: React.FC<NewsCardAnimatedProps> = ({ headlineText }) => {
	const frame = useCurrentFrame();
	const contentRef = useRef<HTMLDivElement>(null);
	const [contentHeight, setContentHeight] = useState(0);


  useLayoutEffect(() => {
    if (contentRef.current) {
      setContentHeight(contentRef.current.scrollHeight + 20);
    }
  }, []);

  const headerTranslateX = interpolate(
    frame,
    [2, 7, totalDuration - 5, totalDuration ],
    [-500, 0, 0, 500],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  const headerOpacity = interpolate(
    frame,
    [0, 5, totalDuration - 5, totalDuration ],
    [0, 1, 1, 0],
    { extrapolateRight: 'clamp' }
  );
 
  const headlineOpacity = interpolate(
    frame,
    [8, 12],
    [0, 1],
    { extrapolateRight: 'clamp' }
  );
  
  const headerSize = interpolate(
    frame,
    [0, 3],
    [0, 1],
    { extrapolateRight: 'clamp' }
  );

  return (
    <div style={{ ...newsCardStyles.newsCard, opacity: headerOpacity }}>
	 <div style={newsCardStyles.breaking}>ORBI NEWS</div>	
      <div ref={contentRef} style={newsCardStyles.newsHeader}>         
          <span style={{...newsCardStyles.headline, transform: `translateX(${headerTranslateX}px)` }}>
            {headlineText} 
          </span>
      </div>  
    </div> 
  );
};

// --- END: Animated Card ---

// --- START: Main Video Component ---

export const NewsVideo: React.FC<z.infer<typeof newsCardProps>> = (props) => {
  const { durationInFrames, fps } = useVideoConfig();
  const { headline1, headline2, headline3, video1Src, video2Src, video3Src } = props;

  return (
    <AbsoluteFill style={{ backgroundColor: "black" }}>
	 <Audio loop src={staticFile('backgroundMusic.wav')} />
      {/* First Sequence */}
      <Sequence from={0} durationInFrames={totalDuration}>
	  
        <NewsCardAnimated headlineText={headline1} /> 
        <OffthreadVideo
          muted
          style={{ zIndex: 0, transform: 'translateY(-150px)', height: 2300, objectFit: "cover" }} 
          src={staticFile(video1Src)}
          startFrom={0}
        />
      </Sequence>

      {/* Second Sequence */}
      <Sequence from={totalDuration} durationInFrames={totalDuration}>
        <NewsCardAnimated headlineText={headline2} />
        <OffthreadVideo
          muted
          style={{ height: 1920, objectFit: "cover" }}
          src={staticFile(video2Src)}
          startFrom={0}
        />
      </Sequence>

      {/* Third Sequence */}
      <Sequence from={totalDuration*2} durationInFrames={totalDuration}>
        <NewsCardAnimated headlineText={headline3} />
        <OffthreadVideo
          muted
          style={{ height: 1920, objectFit: "cover" }}
          src={staticFile(video3Src)}
          startFrom={0}
        />
      </Sequence>	  
    </AbsoluteFill>
  );
};

// --- END: Main Video Component ---
