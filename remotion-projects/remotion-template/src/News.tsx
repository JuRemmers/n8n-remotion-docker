import {
  AbsoluteFill,
  Series,
  Video,
  useVideoConfig, // Make sure useVideoConfig is imported for MyComposition
} from 'remotion';
import { loadFont } from '@remotion/google-fonts/FacultyGlyphic';
import { motion } from 'framer-motion';
import styled from 'styled-components';
import { staticFile } from 'remotion';

// Load the custom font using Remotion's Google Fonts utility
loadFont();

// To this (add export):
export type NewsSceneProps = {
  headlineText: string;
  videoSrc: string;
};

// --- Styled Components (remain the same) ---
const Container = styled(AbsoluteFill)`
  font-family: 'Faculty Glyphic', sans-serif;
  overflow: hidden;
`;

const BackgroundVideo = styled(Video)`
  position: absolute;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
`;

const NewsCard = styled.div`
  position: absolute;
  top: 250px;
  left: 50%;
  transform: translateX(-50%);
  border-radius: 2px;
  width: 65%;
  overflow: hidden;
`;

const NewsHeader = styled(motion.div)`
  text-align: center;
  background-color: #9760a8;
  color: white;
  padding: 20px;
  font-size: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
`;

const Breaking = styled.span`
  background-color: black;
  color: white;
  font-weight: bold;
  padding: 10px 20px;
  border-radius: 10px;
  display: inline-block;
  font-size: 24px;
`;

const Headline = styled.span`
  font-weight: bold;
  font-size: 40px;
  text-wrap: wrap;
`;

// --- Remotion Component for a single News Scene (remains the same) ---
export const NewsScene: React.FC<NewsSceneProps> = ({
  headlineText,
  videoSrc,
}) => {
  return (
    <Container>
      <BackgroundVideo src={staticFile({videoSrc})} muted />
      <NewsCard>
        <NewsHeader
          initial={{ x: '-100%' }}
          animate={{ x: '0%' }}
          transition={{
            type: 'tween',
            ease: 'easeOut',
            duration: 0.7,
            delay: 0.3,
          }}
        >
          <Breaking>GAMING NEWS</Breaking>
          <Headline>{headlineText}</Headline>
        </NewsHeader>
      </NewsCard>
    </Container>
  );
};

// --- NEW: Define props for MyComposition ---
interface MyCompositionProps {
  scenes: NewsSceneProps[]; // An array of scene data
}

// Main Remotion composition managing the scenes
export const MyComposition: React.FC<MyCompositionProps> = ({ scenes }) => {
  const { fps } = useVideoConfig();

  // Ensure there's at least one scene to render
  if (!scenes || scenes.length === 0) {
    return <AbsoluteFill style={{ backgroundColor: 'black', color: 'white', justifyContent: 'center', alignItems: 'center' }}>
      <h1>No scenes provided!</h1>
    </AbsoluteFill>;
  }

  return (
    <Series>
      {scenes.map((scene, index) => (
        <Series.Sequence key={index} durationInFrames={10 * fps}>
          <NewsScene headlineText={scene.headlineText} videoSrc={scene.videoSrc} />
        </Series.Sequence>
      ))}
    </Series>
  );
};
