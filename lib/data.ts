export type Series={id:string;slug:string;title:string;description:string;genre:string;cover_url:string;status:string;created_at?:string};
export type Episode={id:string;series_id:string;number:number;title:string;is_free:boolean;published:boolean;created_at?:string};
export type Page={id:string;episode_id:string;position:number;image_url:string;caption:string|null};
export const demoSeries:Series[]=[
{id:'s1',slug:'margaash-chamaig-tanihgui',title:'Маргааш чамайг танихгүй',genre:'Романтик · Нууцлаг',description:'Нэг нь өдөр бүр дурлана. Нөгөө нь өдөр бүр мартана. Номин, Тэмүүлэн хоёрын түүх өмнө нь арван найман удаа эхэлсэн байжээ.',cover_url:'/covers/memory.svg',status:'ongoing'},
{id:'s2',slug:'minii-orond-amidardag-ohin',title:'Миний оронд амьдардаг охин',genre:'Триллер · Нууцлаг',description:'Өөрийнхөө аваагүй зургуудыг харах болсон охин хэн нэгэн түүний амьдралаар амьдарч байгааг мэднэ.',cover_url:'/covers/mirror.svg',status:'coming'},
{id:'s3',slug:'doloo-dahi-amidraliin-hatan',title:'Долоо дахь амьдралын хатан',genre:'Түүхэн · Фантази',description:'Зургаан амьдралдаа амь алдсан хатан долоо дахь амьдралдаа хувь заяагаа өөрчилнө.',cover_url:'/covers/queen.svg',status:'coming'}];
export const demoEpisodes:Episode[]=[{id:'e1',series_id:'s1',number:1,title:'04:17',is_free:true,published:true},{id:'e2',series_id:'s1',number:2,title:'Анхны уулзалт №2',is_free:true,published:false},{id:'e3',series_id:'s1',number:3,title:'Мартахгүй байх 100 арга',is_free:true,published:false},{id:'e4',series_id:'s1',number:4,title:'Бид өмнө нь үнсэлцэж байсан уу?',is_free:false,published:false}];
export const demoPages:Page[]=[
{id:'p1',episode_id:'e1',position:1,image_url:'/panels/one.svg',caption:'04:17 — Тэмүүлэн хар дарсан зүүднээс цочин сэрлээ.'},
{id:'p2',episode_id:'e1',position:2,image_url:'/panels/two.svg',caption:'«Би... хэнийг зүүдэлсэн юм бол?»'},
{id:'p3',episode_id:'e1',position:3,image_url:'/panels/three.svg',caption:'Толин дээр: «Номин гэдэг охинтой дахиж битгий уулз.»'},
{id:'p4',episode_id:'e1',position:4,image_url:'/panels/four.svg',caption:'«Чи түүнийг санавал тэр үхнэ.»'},
{id:'p5',episode_id:'e1',position:5,image_url:'/panels/five.svg',caption:'Өмнөх орой. Улаанбаатарт бороо орсоор...'},
{id:'p6',episode_id:'e1',position:6,image_url:'/panels/six.svg',caption:'«Номин, энэ бидний анхны уулзалт биш. Арван ес дэх удаа.»'}];