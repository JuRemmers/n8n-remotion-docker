import React from "react";
import {
  AbsoluteFill,
  useCurrentFrame,
  interpolate,
  Easing,
  useVideoConfig,
} from "remotion";
import { z } from "zod";

export const CompSchema = z.object({
  headline: z.string(),
  imgUrl: z.string(),
});

function getAdaptiveFontSize(divWidth: number) {
  const minWidth = 200;
  const maxWidth = 900;
  const minFontSize = 1;
  const maxFontSize = 180;

  if (divWidth <= minWidth) {
    return minFontSize;
  }
  if (divWidth >= maxWidth) {
    return maxFontSize;
  }

  const scale = (divWidth - minWidth) / (maxWidth - minWidth);
  return minFontSize + scale * (maxFontSize - minFontSize);
}

// Scales font size down when text length is long
function getLengthScale(headline: string) {
  const maxLength = 20; // characters at which scaling starts
  if (headline.length <= maxLength) return 1;
  // Scale down from 1 to 0.6 for very long headlines (arbitrary floor)
  const scale = maxLength / headline.length;
  return Math.max(0.6, scale);
}

export const MyComposition: React.FC<z.infer<typeof CompSchema>> = ({
  headline,
  imgUrl,
}) => {
  const frame = useCurrentFrame();
  const { durationInFrames } = useVideoConfig();

  const divWidth = 1080 * 0.5; // 50% of full width

  // Base font size adapted to container width
  const baseFontSize = getAdaptiveFontSize(divWidth);
  // Length scale applied to prevent overflow for long headlines
  const lengthScale = getLengthScale(headline);
  // Final font size
  const fontSize = baseFontSize * lengthScale;

const maxShiftPx = 100; // how much to shift right at start
// Interpolate from maxShiftPx to 0px
const bgShiftPx = interpolate(frame-1, [0, durationInFrames], [maxShiftPx, 0]);

const safeBgShiftPx = isNaN(bgShiftPx) ? 0 : bgShiftPx;

  // Animate white box sliding from bottom up over 15 frames
  const slideY = interpolate(frame, [0, 15], [100, 0], {
    easing: Easing.out(Easing.cubic),
  });

  // Animate fade-in of the white box over 15 frames
  const opacity = interpolate(frame, [0, 15], [0, 1]);

  const absContainer: React.CSSProperties = {
    backgroundImage: `url(${imgUrl})`,
    backgroundSize: "cover",
    backgroundRepeat: "no-repeat",
    backgroundPosition: `calc(50% + ${safeBgShiftPx}px) center`,
    width: "100%",
    height: "100%",
  };

  const animatedDivStyle: React.CSSProperties = {
    backgroundColor: "white",
    width: "50%",
    height: "350px",
    position: "absolute",
    left: "25%",
    top: 200,
    transform: 0,opacity,
    overflow: "hidden",
    justifyContent: "center",
    alignItems: "center",
    boxSizing: "border-box",
    textAlign: "center",
    borderRadius: 20,
  };

  const titleStyle: React.CSSProperties = {
    fontSize: `60px`,
    margin: 0,
    fontWeight: 700,
    width: "100%",
    overflowWrap: "break-word",
    wordBreak: "break-word",
    whiteSpace: "normal",
  };

const subjectStyle: React.CSSProperties = {
    	backgroundColor: "purple",
	height: "80px",
	width: "100%",
	fontSize: "50px",
	color: "white",
  };

  return (
    <AbsoluteFill style={absContainer}>
      <div style={animatedDivStyle}>
	<div style={subjectStyle}>News</div>
        <h1 style={titleStyle}>{headline}</h1>
      </div>
    </AbsoluteFill>
  );
};
