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


// --- START: Styles (unchanged) ---

export const newsCardStyles = {
  newsCard: {
    position: 'absolute',
    top: 140,
    left: '50%',
    transform: 'translateX(-50%)',
    borderRadius: 5,
    width: '65%',
    overflow: 'hidden',
  },
  newsHeader: {
    textAlign: 'center',
    backgroundColor: '#9760a8',
    color: 'white',
    padding: 20,
    fontSize: 20,
    display: 'flex',
    flexDirection: 'column',
    gap: 20,
  },
  breaking: {
    backgroundColor: 'black',
    color: 'white',
    fontWeight: 'bold',
    padding: '10px 10px',
    borderRadius: 10,
    display: 'inline-block',
    fontSize: 24,
  },
  headline: {
    fontWeight: 'bold',
    fontSize: 40,
    textWrap: 'wrap',
  },
};

// --- END: Styles ---


// --- START: Schema for HelloWorld Props (NEW/UPDATED) ---

export const newsCardProps = z.object({
  // New props for headlines
  headline1: z.string().default("Default Headline for First Sequence"),
  headline2: z.string().default("Default Headline for Second Sequence"),
  headline3: z.string().default("Default Headline for Third Sequence"),

  // New props for video sources
  // Using z.string().url() to enforce valid URLs
  video1Src: z.string().url().default("https://video.akamai.steamstatic.com/store_trailers/257116423/movie_max_vp9.webm?t=1742408108"),
  video2Src: z.string().url().default("https://video.akamai.steamstatic.com/store_trailers/257116423/movie_max_vp9.webm?t=1742408108"),
  video3Src: z.string().url().default("https://video.akamai.steamstatic.com/store_trailers/257116423/movie_max_vp9.webm?t=1742408108"),


  // Optional: Add a prop for background music if you want to change it
  // backgroundMusicSrc: z.string().default("backgroundMusic.wav"),
});

// --- END: Schema for HelloWorld Props ---


// --- START: NewsCardAnimated Component (unchanged logic, still internal useCurrentFrame) ---

interface NewsCardAnimatedProps {
  headlineText: string;
}

export const NewsCardAnimated: React.FC<NewsCardAnimatedProps> = ({ headlineText }) => {
  const frame = useCurrentFrame();

  const headerTranslateX = interpolate(
    frame,
    [5, 15],
    [-120, 0],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  const headerOpacity = interpolate(
    frame,
    [0, 10],
    [0, 1],
    { extrapolateRight: 'clamp' }
  );

  return (
    <div style={newsCardStyles.newsCard}>
      <div style={{ ...newsCardStyles.newsHeader, opacity: headerOpacity }}>
        <span style={{ ...newsCardStyles.breaking, transform: `translateX(${headerTranslateX}%)` }}>BREAKING NEWS</span>
        <span style={{ ...newsCardStyles.headline, transform: `translateX(${headerTranslateX}%)` }}>
          {headlineText}
        </span>
      </div>
    </div>
  );
};
// --- END: NewsCardAnimated Component ---


// --- START: HelloWorld Component (UPDATED to use props) ---

export const NewsVideo: React.FC<z.infer<typeof helloWorldProps>> = (props) => {
  const { durationInFrames, fps } = useVideoConfig();

  // Destructure the new props
  const { headline1, headline2, headline3, video1Src, video2Src, video3Src } = props;

  return (
    <AbsoluteFill style={{ backgroundColor: "black" }}>
      {/* First Sequence */}
      <Sequence from={0} durationInFrames={120}>
        <NewsCardAnimated
          headlineText={headline1} // Using the prop
        />
        <OffthreadVideo
          muted
          style={{ height: 1920, objectFit: "cover" }}
          src={staticFile(video1Src)} // Using the prop
          startFrom={0}
        />
      </Sequence>

      {/* Second Sequence */}
      <Sequence from={120} durationInFrames={120}>
        <NewsCardAnimated
          headlineText={headline2} // Using the prop
        />
        <OffthreadVideo
          muted
          style={{ height: 1920, objectFit: "cover" }}
          src={staticFile(video2Src)} // Using the prop
          startFrom={0}
        />
      </Sequence>
{/* Third Sequence */}
      <Sequence from={240} durationInFrames={120}>
        <NewsCardAnimated
          headlineText={headline3} // Using the prop
        />
        <OffthreadVideo
          muted
          style={{ height: 1920, objectFit: "cover" }}
          src={staticFile(video3Src)} // Using the prop
          startFrom={0}
        />
      </Sequence>
    </AbsoluteFill>
  );
};
// --- END: HelloWorld Component ---
