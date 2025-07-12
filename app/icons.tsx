export const LogoSpirit = ({ size = 16 }: { size?: number }) => (
  <svg
    height={size}
    strokeLinejoin="round"
    viewBox="0 0 16 16"
    width={size}
    style={{ color: "currentcolor" }}
  >
    {/* Face outline */}
    <path
      d="M8 2C4.68629 2 2 4.68629 2 8C2 11.3137 4.68629 14 8 14C11.3137 14 14 11.3137 14 8C14 4.68629 11.3137 2 8 2Z"
      stroke="currentColor"
      fill="none"
      strokeWidth="1.5"
    />
    
    {/* Third eye */}
    <circle
      cx="8"
      cy="6"
      r="0.75"
      fill="currentColor"
    />

    {/* Peaceful closed eyes */}
    <path
      d="M5 8C5.5 7.5 6.2 7.5 6.7 8"
      stroke="currentColor"
      strokeWidth="1.2"
      strokeLinecap="round"
      fill="none"
    />
    <path
      d="M9.3 8C9.8 7.5 10.5 7.5 11 8"
      stroke="currentColor" 
      strokeWidth="1.2"
      strokeLinecap="round"
      fill="none"
    />

    {/* Gentle smile */}
    <path
      d="M5.5 10C6.5 11 9.5 11 10.5 10"
      stroke="currentColor"
      strokeWidth="1.2"
      strokeLinecap="round"
      fill="none"
    />

    {/* Aura rays */}
    <path
      d="M8 0.5V1.5M8 14.5V15.5M15.5 8H14.5M1.5 8H0.5M13.5 2.5L12.5 3.5M2.5 13.5L3.5 12.5M13.5 13.5L12.5 12.5M2.5 2.5L3.5 3.5"
      stroke="currentColor"
      strokeWidth="1"
      strokeLinecap="round"
    />
  </svg>
);
