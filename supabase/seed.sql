-- Optional sample content for a clean Pink Verse project. Run AFTER schema.sql.
insert into public.series(slug,title,description,genre,cover_url,status) values
('margaash-chamaig-tanihgui','Маргааш чамайг танихгүй','Нэг нь өдөр бүр дурлана. Нөгөө нь өдөр бүр мартана. Номин, Тэмүүлэн хоёрын түүх өмнө нь арван найман удаа эхэлсэн байжээ.','Романтик · Нууцлаг','/covers/memory.svg','ongoing'),
('minii-orond-amidardag-ohin','Миний оронд амьдардаг охин','Өөрийнхөө аваагүй зургуудыг харах болсон охин.','Триллер · Нууцлаг','/covers/mirror.svg','coming'),
('doloo-dahi-amidraliin-hatan','Долоо дахь амьдралын хатан','Долоо дахь амьдралдаа хувь заяагаа өөрчилнө.','Түүхэн · Фантази','/covers/queen.svg','coming')
on conflict(slug) do nothing;
insert into public.episodes(series_id,number,title,is_free,published)
select s.id, x.number,x.title,x.is_free,x.published from public.series s cross join (values
(1,'04:17',true,true),(2,'Анхны уулзалт №2',true,false),(3,'Мартахгүй байх 100 арга',true,false),(4,'Бид өмнө нь үнсэлцэж байсан уу?',false,false)
) as x(number,title,is_free,published) where s.slug='margaash-chamaig-tanihgui'
on conflict(series_id,number) do nothing;
insert into public.episode_pages(episode_id,position,image_url,caption)
select e.id,x.position,x.image_url,x.caption from public.episodes e join public.series s on s.id=e.series_id cross join (values
(1,'/panels/one.svg','04:17 — Тэмүүлэн хар дарсан зүүднээс цочин сэрлээ.'),
(2,'/panels/two.svg','«Би... хэнийг зүүдэлсэн юм бол?»'),
(3,'/panels/three.svg','Толин дээр: «Номин гэдэг охинтой дахиж битгий уулз.»'),
(4,'/panels/four.svg','«Чи түүнийг санавал тэр үхнэ.»'),
(5,'/panels/five.svg','Өмнөх орой. Улаанбаатарт бороо орсоор...'),
(6,'/panels/six.svg','«Номин, энэ бидний анхны уулзалт биш. Арван ес дэх удаа.»')
) as x(position,image_url,caption) where s.slug='margaash-chamaig-tanihgui' and e.number=1
on conflict(episode_id,position) do nothing;