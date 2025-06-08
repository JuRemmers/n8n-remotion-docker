import React from 'react';
import { z } from 'zod';
import { useCurrentFrame, useVideoConfig, interpolate, AbsoluteFill } from 'remotion';

export const ItemSchema = z.object({
  title: z.string(),
  image: z.string().url(),
});

export const DataSchema = z.object({
  data: z.array(ItemSchema).min(1),
  durationPerPage: z.number().min(1),
});

type PagesProps = z.infer<typeof DataSchema>;

export const PagesComp: React.FC<PagesProps> = ({ data, durationPerPage }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <>
      {data.map((item, index) => {
        const startFrame = index * durationPerPage;
        const endFrame = startFrame + durationPerPage;
        
        // Only render if this page should be visible
        if (frame < startFrame || frame >= endFrame) {
          return null;
        }

        return (
          <div
            key={index}
          >
            {/* Background image with horizontal pan */}
	<AbsoluteFill>
            <img
              src={item.image}
              alt={item.title}
              style={{
                position: 'absolute',
                top: 0,
                left: 0,
                height: '100%',
                objectFit: 'cover',
                zIndex: 0,
              }}
            />
            {/* Text content */}
            <h1
              style={{
                fontSize: '3rem',
                marginBottom: '2rem',
                textAlign: 'center',
                color: '#fff',
                position: 'relative',
                zIndex: 1,
                textShadow: '0 0 10px rgba(0,0,0,0.7)',
                maxWidth: '80%',
              }}
            ><span style={{
                backgroundColor: 'white',
		padding: '5px',
              }}>
              {item.title}
	     </span>
            </h1>
	</AbsoluteFill>
          </div>
        );
      })}
    </>
  );
};