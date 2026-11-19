import { cn } from "@/lib/utils";

type Variant = "tile" | "light" | "color";

/** Turminha: uma bola grande e duas menores se abraçando, com um ponto verde no topo (grade de 120). */
function Mark({ variant }: { variant: Exclude<Variant, "tile"> }) {
  const light = variant === "light";
  return (
    <>
      <circle
        cx="30"
        cy="74"
        r="19"
        fill={light ? "#fff" : "#7b4dff"}
        fillOpacity={light ? 0.55 : 0.35}
      />
      <circle
        cx="90"
        cy="74"
        r="19"
        fill={light ? "#fff" : "#3d7bff"}
        fillOpacity={light ? 0.55 : 0.35}
      />
      <circle
        cx="60"
        cy="68"
        r="27"
        fill={light ? "#fff" : "#6a5cff"}
        fillOpacity={light ? 0.95 : 1}
      />
      <circle cx="60" cy="26" r="9" fill={light ? "#3ee0a9" : "#00c884"} />
    </>
  );
}

/**
 * Logo do Espaço Kids. `tile` (padrão) vem num quadrado arredondado com o degradê da marca; `light`
 * é só a marca em tons claros, para usar sobre o degradê; `color` é só a marca colorida, para
 * fundos comuns (menu lateral, cabeçalho do site).
 */
export function AppLogo({
  className,
  variant = "tile",
}: {
  className?: string;
  variant?: Variant;
}) {
  return (
    <svg
      viewBox={variant === "tile" ? "0 0 120 120" : "0 0 120 108"}
      role="img"
      aria-label="Espaço Kids"
      className={cn("shrink-0", className)}
    >
      {variant === "tile" ? (
        <>
          <defs>
            <linearGradient id="kids-logo-bg" x1="0" y1="0" x2="1" y2="1">
              <stop offset="0" stopColor="#7b4dff" />
              <stop offset="1" stopColor="#3d7bff" />
            </linearGradient>
          </defs>
          <rect width="120" height="120" rx="27" fill="url(#kids-logo-bg)" />
          <g transform="translate(60 56) scale(0.66) translate(-60 -56)">
            <circle cx="30" cy="74" r="19" fill="#fff" fillOpacity={0.55} />
            <circle cx="90" cy="74" r="19" fill="#fff" fillOpacity={0.55} />
            <circle cx="60" cy="68" r="27" fill="#fff" fillOpacity={0.95} />
            <circle cx="60" cy="26" r="9" fill="#00c884" />
          </g>
        </>
      ) : (
        // A marca ocupa de y=17 a y=95: o recorte aproxima o logo do texto ao lado.
        <g transform="translate(0 -8)">
          <Mark variant={variant} />
        </g>
      )}
    </svg>
  );
}

const LOADER_FILLS = ["#b9a5ff", "#6a5cff", "#7ba5ff", "#00c884"];
const LOADER_FILLS_BUTTON = [
  "currentColor",
  "currentColor",
  "currentColor",
  "#3ee0a9",
];
const LOADER_SPOTS: [number, number, number][] = [
  [30, 74, 19],
  [60, 68, 27],
  [90, 74, 19],
  [60, 26, 9],
];

/**
 * Indicador de carregamento da marca: as bolas acendem uma de cada vez (esquerda, centro, direita
 * e o ponto verde) e voltam ao início. `light` é para dentro de botões: bolas na cor do texto.
 */
export function LogoLoader({
  className,
  label,
  light = false,
}: {
  className?: string;
  label?: string;
  light?: boolean;
}) {
  return (
    <svg
      viewBox="0 0 120 108"
      role={label ? "status" : undefined}
      aria-label={label}
      aria-hidden={label ? undefined : true}
      className={cn("shrink-0", className)}
    >
      <g transform="translate(0 -8)">
        {LOADER_SPOTS.map(([cx, cy, r], i) => (
          <circle
            key={i}
            className="logo-loader-piece"
            style={{ animationDelay: `${i * 0.6}s` }}
            cx={cx}
            cy={cy}
            r={r}
            fill={(light ? LOADER_FILLS_BUTTON : LOADER_FILLS)[i]}
          />
        ))}
      </g>
    </svg>
  );
}
