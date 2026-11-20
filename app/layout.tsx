import './globals.css';
import type { Metadata } from 'next';
export const metadata:Metadata={title:'Pink Verse | Түүх бүр өөр ертөнц',description:'Монгол хэл дээрх оригинал манхуа, вэбтүүн комикийн ертөнц'};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="mn"><body>{children}</body></html>}