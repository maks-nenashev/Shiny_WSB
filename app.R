library(shiny)
library(bs4Dash)
library(dplyr)
library(readr)
library(plotly)
library(leaflet)
library(fresh)
library(viridis)
library(fst)
library(lubridate)
library(forecast)

plot_colour <- "#8965CD"
custom_colour <- viridis::mako(n = 15) # mako, turbo, magma, plasma, inferno, cividis, rocket
custom_colour2 <- viridis::turbo(n = 15) 

theme <- create_theme(
  bs4dash_color(
    lime = "#52A1A5",
    olive = "#4A9094",
    orange = "#ff851b",
    purple = "#8965CD",
    #info = "#52A1A5"
    ),
  bs4dash_status(
    primary = "#E1EDED",
    info = "#E4E4E4"
  )
)

# === 📁 Ładowanie danych ===
#file_path <- "/home/maks/Документы/Data_frame/reestrtz/tz_2024_filtered.fst"
#cars_data <- read_fst(file_path)
#//////////////////////////////////////////////////////////////////////////////////////////////////////

ui <- dashboardPage(
  title = "WSB-NLU", # Название
  freshTheme = theme,
  dark = NULL,
  help = NULL,
  fullscreen = TRUE,
  scrollToTop = TRUE,
  
  # Header ----
  header = dashboardHeader(
    status = "lime",
    title = dashboardBrand(
      title = "WSB-NLU",
      color = "olive",
      image = "https://maksym-nenashev.imgix.net/WSB-NLU.jpeg"
    ),
    controlbarIcon = icon("circle-info"),
    fixed = TRUE,
    rightUi = dropdownMenu(
      badgeStatus = "info",
      type = "notifications",
      notificationItem(
        text = "Success",
        status = "success",
        icon = icon("circle-check")
      ),
      notificationItem(
        text = "Warning",
        status = "warning",
        icon = icon("circle-exclamation")
      ),
      notificationItem(
        text = "Error",
        status = "danger",
        icon = icon("circle-xmark")
      )
    )
  ),
  
  # Sidebar ----
  sidebar = dashboardSidebar(
    sidebarMenu(
      id = "sidebarMenuid",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Dane rejestracyjne", tabName = "Dane_rejestracyjne", icon = icon("bar-chart")),
      menuItem("Dane rejestracyjne 2", tabName = "Dane_rejestracyjne_2", icon = icon("bar-chart")),
      menuItem("Prognoza rejestracji", tabName = "Prognoza_rejestracji", icon = icon("bar-chart")),
      #menuItem("Dane rejestracyjne 2024", tabName = "tab_2024", icon = icon("bar-chart")),
      menuItem("Informacje o projekcie", tabName = "opis_techniczny", icon = icon("bar-chart"))
    )
  ),
  
  # Body ----
  body = dashboardBody(
    tabItems(
      # ---- Home tab ----
      tabItem(
        tabName = "home",
        tags$head(
          tags$style(HTML("
            .nav-pills .nav-link {
              background-color: #f8f9fa;
              color: black !important;
              margin-right: 5px;
              border-radius: 6px;
              font-weight: 500;
              transition: background-color 0.3s ease, color 0.3s ease;
            }
            .nav-pills .nav-link:hover {
              background-color: #ffd699;
              color: black;
            }
            .nav-pills .nav-link.active {
              background-color: #FF851B !important;
              color: white !important;
              font-weight: bold;
            }
            .tab-content {
              background-color: #ffffff;
              padding: 20px;
              border-radius: 0 0 10px 10px;
            }
            .hero-box {
              background-image: url('https://cdn.statically.io/img/wallpaperaccess.com/full/1119564.jpg');
              background-size: cover;
              background-position: center;
              color: white;
              border-radius: 20px;
              padding: 60px 30px;
              margin-bottom: 30px;
              box-shadow: 0 10px 25px rgba(0,0,0,0.3);
              position: relative;
              overflow: hidden;
              animation: fade-in 1.5s ease-in;
            }
            .hero-box::before {
              content: '';
              position: absolute;
              top: 0; left: 0; right: 0; bottom: 0;
              background: rgba(0, 0, 0, 0.55);
              z-index: 1;
            }
            .hero-box > * {
              position: relative;
              z-index: 2;
            }
            .hero-box h2 {
              font-size: 3rem;
              font-weight: 700;
              margin-bottom: 20px;
            }
            .hero-box p {
              font-size: 1.25rem;
              margin-bottom: 30px;
            }
            .hero-box img {
              max-width: 100%;
              border-radius: 10px;
              box-shadow: 0 5px 15px rgba(0,0,0,0.25);
            }
            @keyframes fade-in {
              0% { opacity: 0; transform: translateY(20px); }
              100% { opacity: 1; transform: translateY(0); }
            }
          "))
        ),
        tags$div(
          class = "hero-box text-center",
          tags$img(
            src = "https://maksym-nenashev.imgix.net/WSB-NLU.jpeg",
            style = "max-height: 100px; margin-bottom: 40px; border-radius: 50%; border: 3px solid white;"
          ),
          tags$h2("🎓 Praca Magisterska 2025"),
          tags$p("Projekt dyplomowy magistra Analizy Danych!"),
          tags$img(src = "https://maksym-nenashev.imgix.net/wsb-nlu.jpg")
        ),
        fluidRow(
          userBox(style = "box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 12px;", # Tenь
            collapsible = FALSE,
            title = userDescription(
              title = "Maksym Nenashev",
              subtitle = HTML("💻 Developer & Data Analyst"),
              image = "https://maksym-nenashev.imgix.net/MN1.png",
              backgroundImage = "https://cdn.statically.io/img/wallpaperaccess.com/full/1119564.jpg",
              type = 1
            ),
            status = "purple",
            HTML("<p class='mb-1'><i class='fas fa-laptop-code text-success'></i> Koduję lepiej niż ChatGPT — prawie.</p>"),
            footer = tagList(
              tags$small(class = "text-muted", style = "font-size: 18px;",
                         HTML("📧 <a href='mailto:maksym@nenashev.net' style='color: inherit;'>maksym@nenashev.net</a>")
              ),
              tags$small(class = "text-muted ms-3", style = "font-size: 18px;",
                         HTML("   🌍 <a href='https://www.nenashev.net' target='_blank' style='color: inherit; text-decoration: underline;'>www.nenashev.net</a>")
              ),
              tags$div(class = "mt-2", style = "font-size: 18px;",
                       HTML("
             <i class='fab fa-github text-dark'></i> 
             <a href='https://github.com/maks-nenashev' target='_blank' style='text-decoration: none; color: #000;'>GitHub</a>
             &nbsp;&nbsp;
             <i class='fab fa-linkedin text-blue'></i> 
             <a href='https://www.linkedin.com/in/maksym-nenashev-0627ab220' target='_blank' style='text-decoration: none;'>LinkedIn</a>
               ")
              )
             )
            ),
          userBox(style = "box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 12px;",#Tenь
            collapsible = FALSE,
            title = userDescription(
              title = "Anna Nenasheva",
              subtitle = HTML("📊 Data Analyst"),
              image = "https://maksym-nenashev.imgix.net/Anna2.jpg",
              backgroundImage = "https://cdn.statically.io/img/wallpaperaccess.com/full/1119564.jpg",
              type = 1
            ),
            status = "lightblue",
            HTML("<p class='mb-1'><i class='fas fa-brain text-primary'></i> Super impressive bio</p>"),
            footer = tagList(
              tags$small(class = "text-muted", style = "font-size: 20px;", "📧 nenasheva.ani@gmail.com"),
        
              tags$div(class = "mt-2", style = "font-size: 18px;",
                     HTML("
             <i class='fab fa-github text-dark'></i> 
             <a href='https://github.com/maks-nenashev' target='_blank' style='text-decoration: none; color: #000;'>GitHub</a>
             &nbsp;&nbsp;
             <i class='fab fa-linkedin text-blue'></i> 
             <a href='https://www.linkedin.com/in/anna-nenasheva-3b6aa829b' target='_blank' style='text-decoration: none;'>LinkedIn</a>
               ")
              )
            )
          ),
          box(style = "box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 12px;",
            title = "💻 O mnie",
            width = 6,
            status = "lime",
            collapsible = FALSE,
            solidHeader = TRUE,
            HTML("
                <div style='font-size:18px; line-height:1.6;'>
                 <p><i class='fas fa-user'></i> <strong>Autor projektu, analityk danych i programista aplikacji Shiny (i nie tylko 😊)</strong></p>
                 <p><i class='fas fa-graduation-cap'></i> Student kierunku <strong>Analiza Danych (WSB-NLU)</strong>, rocznik 2023-2025</p>
                 <p><i class='fas fa-lightbulb'></i> Specjalizuje się w eksploracji danych, przetwarzaniu ETL, wizualizacjach interaktywnych i modelach prognostycznych (regresje, ARIMA)</p>
              
                 <p><i class='fas fa-rocket'></i> Pasjonat nowych technologii, AI, open data oraz projektów o znaczeniu społecznym</p>
                 <p><i class='fas fa-toolbox'></i> Technologie: <code>R</code>, <code> Shiny</code>, <code> dplyr</code>, <code> plotly</code>, <code> leaflet</code>, <code> ARIMA</code>, <code> ETL</code>, <code> AWS S3</code></p>
                </div>")
           ),
          box(
            style = "box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 12px;",
            title = "📊 O mnie",
            width = 6,
            status = "lightblue",
            collapsible = FALSE,
            solidHeader = TRUE,
            HTML("
                  <div style='font-size:18px; line-height:1.6;'>
                    <p><i class='fas fa-user'></i> <strong>Współautorka projektu, analityczka danych i badaczka trendów rynkowych</strong></p>
                    <p><i class='fas fa-graduation-cap'></i> Studentka kierunku <strong>Analiza Danych (WSB-NLU)</strong>, rocznik 2023–2025</p>
                    <p><i class='fas fa-lightbulb'></i> Specjalizuje się w przygotowaniu danych, analizach opisowych i predykcyjnych, a także w tworzeniu syntetycznych wniosków biznesowych</p>
                    <p><i class='fas fa-heart'></i> Skupiona na aspektach społecznych analityki danych, w tym wpływie mobilności na jakość życia</p>
                    <p><i class='fas fa-toolbox'></i> Technologie: <code>R</code>, <code>dplyr</code>, <code>ggplot2</code>, <code>plotly</code>, <code>tidyr</code>, <code>Shiny</code></p>
                  </div>")
          ),
          userBox(style = "box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 12px;",
            title = userDescription(
              title = "Dr. Katarzyna Jermakowicz",
              subtitle = HTML("🎓 Promoter Pracy Magisterskiej"),
              type = 2,
              image = "https://maksym-nenashev.imgix.net/Katarzyna%20Jermakowicz.jpg"
            ),
            status = "primary",
            gradient = TRUE,
            background = "primary",
            boxToolSize = "xl",
            HTML("<p class='mb-2'>
              <i class='fas fa-university'></i> <strong>Adiunkt</strong> – Wydział Nauk Społecznych i Informatyki, WSB-NLU
              <br><i class='fas fa-calculator'></i> <em>Specjalizacja: matematyka stosowana, statystyka i analiza danych</em>
              </p>"),
            footer = HTML("
             <ul class='list-unstyled mb-0'>
               <li><i class='fas fa-graduation-cap text-info'></i> Absolwentka <strong>Uniwersytet Jagielloński w Krakowie</strong> (1999)</li>
               <li><i class='fas fa-graduation-cap text-info'></i> Doktorat: <strong>University of Hull (UK)</strong>, 2003</li>
               <li><i class='fas fa-chalkboard-teacher text-info'></i> Wykładowczyni <strong>University of Hull</strong> (2000–2004)</li>
               <li><i class='fas fa-university text-info'></i> Od 2004: <strong>Adiunkt w WSB-NLU</strong>, specjalizacja: <em>matematyka stosowana, statystyka i analiza danych</em></li>
               <li><i class='fas fa-book text-info'></i> Autorka wielu publikacji naukowych w zakresie metod ilościowych i analizy danych</li>
               <li><i class='fas fa-user-graduate text-info'></i> Promotorka licznych prac licencjackich i magisterskich</li>
               <li><i class='fas fa-star text-warning'></i> Ceniona za <strong>profesjonalizm, empatię i wysokie standardy dydaktyczne</strong></li>
            </ul>")
            ),
          column( # Button
            width = 6,  # Правая половина экрана
            box(style = "box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 12px;",# Тень
              title = "📥 Pobierz pracę magisterską",
              width = NULL,
              status = "info",
              solidHeader = TRUE,
              tags$div(
                style = "padding: 20px;",
                tags$p("Kliknij przycisk, aby pobrać pełną wersję pracy magisterskiej w formacie PDF."),
                tags$a(
                  href = "praca_magisterska.pdf",  # или публичный S3 URL
                  #src = "https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/pdf/praca_magisterska.pdf",
                  target = "_blank",
                  class = "btn btn-danger btn-lg",
                  icon("file-pdf"),
                  " Pobierz PDF"
                 )
              )
            )
          )# column the-end Button
      
      )
    ),
  #////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       # ---- Dane_rejestracyjne ----
      tabItem(
        tabName = "Dane_rejestracyjne",
        fluidRow(
          column(
            width = 12,
            tags$img(
              style = "width: 100%; max-height: 300px; object-fit: cover; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.2);"
            )
          )
        ),
        fluidRow(
          sortable(
            tabBox(
              title = "TOP",
              width = 12,
              status = "purple",
              solidHeader = TRUE,
              collapsible = FALSE,
              tabPanel("Nowe pojazdy", 
                       plotlyOutput("Liczba_rejestracji", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                                HTML("<p>Wykres przedstawia <strong>liczbę rejestracji nowych pojazdów osobowych</strong> w Ukrainie w latach <strong>2017–2023</strong>.</p>

      <p>📈 W latach 2017–2021 liczba ta utrzymywała się w przedziale <strong>95–177 tys.</strong>, z najwyższą wartością w <strong>2021 roku</strong>.</p>

      <p>📊 Trend ten odzwierciedla rosnące zainteresowanie pojazdami fabrycznie nowymi — zarówno wśród klientów indywidualnych, jak i flot.</p>

      <p>📉 Po 2022 roku nastąpił drastyczny spadek: zaledwie <strong>3 598</strong> rejestracji w 2022 i <strong>3 145</strong> w 2023 roku.</p>

      <p>⚠️ Wynika to z kryzysu wojennego, przerwania dostaw, braku dostępności i zmiany priorytetów nabywców.</p>

      <p>🎯 Wartość tego wskaźnika pozwala analizować nie tylko rynek samochodowy, ale także nastroje konsumenckie i kondycję gospodarczą kraju.</p>"))),
              tabPanel("Używane pojazdy", plotlyOutput("uzywane_pojazdy", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;",
                                HTML("<p>Wykres przedstawia <strong>liczbę rejestracji pojazdów używanych</strong> w Ukrainie w latach <strong>2017–2023</strong>.</p>

      <p>📈 Od <strong>2017 do 2021</strong> roku liczba rejestracji rosła systematycznie – z <strong>656 tys.</strong> do rekordowych <strong>1,65 mln</strong>.</p>

      <p>🔁 Dane pokazują wysokie zainteresowanie pojazdami z rynku wtórnego oraz dobrze rozwinięty import z krajów UE.</p>

      <p>📉 Po <strong>lutym 2022</strong> następuje załamanie – w <strong>2022 i 2023</strong> zarejestrowano odpowiednio <strong>48 930</strong> i <strong>43 131</strong> pojazdów.</p>

      <p>⚠️ Powodem są wojna, chaos logistyczny, uproszczone procedury oraz brak klasycznej rejestracji dla transportów humanitarnych.</p>

      <p>🎯 Wykres ten pozwala ocenić skalę regresji rynku wtórnego oraz wyzwania dla polityki mobilności i bezpieczeństwa w najbliższych latach.</p>"))),
              tabPanel("Nowe vs używane pojazdy", plotlyOutput("new_used", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                                HTML("<p>Wykres przedstawia <strong>rejestracje nowych i używanych pojazdów</strong> oraz ich łączną sumę w latach <strong>2017–2023</strong>.</p>

      <p>🔵 <strong>Nowe pojazdy</strong> stanowiły mniejszość, osiągając maksimum <strong>177 307</strong> sztuk w roku 2021.</p>

      <p>🔴 <strong>Pojazdy używane</strong> zdominowały rynek, z rekordową liczbą ponad <strong>1,6 mln</strong> rejestracji rocznie.</p>

      <p>🟢 W 2021 roku odnotowano najwyższą łączną liczbę rejestracji: <strong>1 831 222</strong>.</p>

      <p>📉 W latach <strong>2022–2023</strong> nastąpiło dramatyczne załamanie rynku — liczba rejestracji spadła o ponad <strong>97%</strong>.</p>

      <p>🎯 Wykres odzwierciedla wpływ wojny na mobilność i stanowi ważny wskaźnik kondycji rynku motoryzacyjnego w Ukrainie.</p>"))),
              tabPanel("Typ właściciela pojazdów", plotlyOutput("priwat", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                                HTML("<p>Wykres przedstawia <strong>roczną liczbę rejestracji pojazdów</strong> w podziale na typ właściciela: <strong>Prywatny</strong> oraz <strong>Inny</strong> w latach <strong>2017–2023</strong>.</p>

      <p>🟩 <strong>Właściciele prywatni</strong> stanowili zdecydowaną większość — w 2021 roku ich liczba rejestracji przekroczyła <strong>2,2 mln</strong>.</p>

      <p>🟥 <strong>Inni właściciele</strong> (firmy, instytucje) utrzymywali stabilny udział aż do roku 2021, kiedy zanotowano zauważalny wzrost.</p>

      <p>📉 Po 2021 roku nastąpił gwałtowny spadek rejestracji w obu grupach, co jest bezpośrednim skutkiem wojny oraz ograniczeń administracyjnych.</p>

      <p>🎯 Ten podział pozwala analizować strukturę rynku i rolę sektora prywatnego oraz instytucjonalnego w ukraińskiej mobilności.</p>"))),
              tabPanel("Top-5 Kolory pojazdów", plotlyOutput("top_colors_by_year", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                                HTML("<p>Wykres przedstawia <strong>pięć najczęściej wybieranych kolorów nadwozia samochodów</strong> rejestrowanych w Ukrainie w latach <strong>2017–2023</strong>.</p>

      <p>⬛ <strong>Szary</strong> dominuje przez cały okres — w 2021 roku osiągnął rekordowy poziom ponad <strong>713 tys.</strong> rejestracji.</p>

      <p>⬜ <strong>Biały</strong> oraz 🖤 <strong>czarny</strong> kolor utrzymują wysoką popularność, pozostając w ścisłej czołówce.</p>

      <p>🔵 <strong>Niebieski</strong> i 🔴 <strong>czerwony</strong> cieszą się umiarkowanym zainteresowaniem — ten ostatni z wyraźną tendencją spadkową.</p>

      <p>📉 Od 2022 roku liczba rejestracji pojazdów w każdym kolorze dramatycznie spadła, co ma związek z wybuchem wojny i kryzysem logistycznym.</p>

      <p>🎯 Kolor pojazdu odzwierciedla preferencje estetyczne konsumentów, ale także uwarunkowania praktyczne, kulturowe i ekonomiczne.</p>"))),
              
              tabPanel("Top-3 marki pojazdów", plotlyOutput("Top_3", height = "630px"), 
                      tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;",
                              HTML("<p>Na powyższym wykresie przedstawiono <strong>trzy najczęściej rejestrowane marki pojazdów</strong> w Ukrainie w każdym roku w okresie <strong>2017–2023</strong>.</p>

      <p>🔝 Wśród liderów dominują takie marki jak <strong>Volkswagen</strong>, <strong>Renault</strong>, <strong>BA3 (Łada)</strong> oraz <strong>Mercedes-Benz</strong>,
      które pojawiały się najczęściej w zestawieniach rocznych. W poszczególnych latach możemy zaobserwować zmiany dominacji —
      szczególnie zauważalny jest <strong>systematyczny wzrost udziału Volkswagena</strong>, który w 2021 roku osiągnął rekordowy poziom ponad <strong>270 tys.</strong> rejestracji.</p>

      <p>📉 W latach <strong>2022–2023</strong> nastąpił gwałtowny spadek liczby rejestracji wszystkich marek —
      bezpośrednio związany z wojną oraz trudną sytuacją logistyczno-gospodarczą.</p>

      <p>📌 Ciekawostką jest fakt, że marka <strong>BA3</strong>, mimo ogólnego spadku popularności w Europie,
      utrzymywała się w czołówce ukraińskiego rynku aż do 2021 roku.</p>

      <p>🧠 Wykres ten doskonale pokazuje, jak dynamicznie może zmieniać się struktura preferencji konsumentów
      w sektorze motoryzacyjnym — pod wpływem czynników ekonomicznych, dostępności aut, a także wydarzeń geopolitycznych.</p>"))),
              
              tabPanel("Transport medyczny", plotlyOutput("med_cars", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;",
                            HTML("<p>Na powyższym wykresie przedstawiono <strong>dynamikę rejestracji pojazdów medycznych (karetek)</strong> na Ukrainie w latach <strong>2017–2023</strong>.</p>
    <p>
         <span style='color: #2563eb;'>🔹</span> W latach 2017–2021 obserwowano systematyczny wzrost liczby rejestracji — z <strong>1 430</strong> w 2017 r. do rekordowych <strong>3 668</strong> w 2021 r.
         Był to efekt modernizacji taboru, wdrażania programów rządowych oraz zwiększonego zapotrzebowania na nowoczesny transport medyczny.
    </p>
    <p>
         <span style='color: #dc2626;'>❗</span> Od 2022 roku nastąpił <strong>gwałtowny spadek rejestracji</strong> — zaledwie <strong>67</strong> karetek w 2022 r. i <strong>98</strong> w 2023 r.
         Zjawisko to jest bezpośrednio związane z wybuchem pełnoskalowej wojny, która doprowadziła do zahamowania procesów administracyjnych, utraty i mobilizacji pojazdów oraz priorytetyzacji innych zadań państwowych.
     </p>
     <p>
         <span style='color: #059669;'>📝</span> Spadek rejestracji w ostatnich dwóch latach nie jest wynikiem naturalnych trendów rynkowych, lecz bezpośrednią konsekwencją sytuacji wojennej.
         Analizując te dane, należy uwzględniać kontekst geopolityczny i specyfikę warunków kryzysowych.
     </p>
     <p>
         W latach <strong>2022–2023</strong> na Ukrainę sprowadzono ponad <strong>173&nbsp;000</strong> pojazdów jako pomoc humanitarna — w tym karetki pogotowia oraz pojazdy wojskowe.
     </p>
     <p>
        <span style='color: #2563eb;'>🔹</span> Import na tak dużą skalę był możliwy dzięki uproszczonym procedurom celnym oraz sytuacji wojennej, która wymagała błyskawicznego wsparcia transportowego.
     </p>
     <p>
        <span style='color: #dc2626;'>❗</span> Warto zauważyć, że <strong>znaczna część tych pojazdów nie została formalnie zarejestrowana</strong> w klasycznych bazach policyjnych — z powodu uproszczonej procedury, specyfiki pomocy humanitarnej oraz trudnych warunków wojennych.
     </p>
     <p>
        <span style='color: #059669;'>📝</span> Równolegle odnotowano wzrost liczby naruszeń przy imporcie, co może być efektem szybkiego tempa i wysokiej liczby transakcji w wyjątkowych okolicznościach.
     </p>")))
            )
          )
        )
      ),
      
      # ---- Dane_rejestracyjne_2 ------------------------------------------------------------------------------
      tabItem(
        tabName = "Dane_rejestracyjne_2",
        fluidRow(
          column(
            width = 12,
            tags$img(
              style = "width: 100%; max-height: 300px; object-fit: cover; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.2);"
            )
          )
        ),
        fluidRow(
          sortable(
            tabBox(
              title = "TOP",
              width = 12,
              status = "purple",
              solidHeader = TRUE,
              collapsible = FALSE,
              tabPanel("Rejestracje głównych typów pojazdów", plotlyOutput("fig", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                       HTML("<p>
      Powyższy wykres przedstawia roczną liczbę rejestracji głównych typów pojazdów w Ukrainie w latach 2017–2023.
      Dane zostały podzielone według kategorii pojazdów: <strong>samochody osobowe</strong>, <strong>ciężarowe</strong>,
      <strong>autobusy</strong>, <strong>przyczepy</strong> oraz <strong>naczepy</strong>.
      </p>

      <p>📊 <strong>Samochody osobowe</strong> dominują w każdym roku, stanowiąc największy odsetek wszystkich rejestracji.
      Widać wyraźny wzrost liczby aż do roku 2021, kiedy to osiągnięto szczytowy poziom ponad 2 milionów pojazdów.</p>

      <p>⚠️ Spadek po 2021 roku jest radykalny i jednoznacznie związany z wybuchem wojny w lutym 2022 roku.
      Rejestracje wszystkich typów pojazdów drastycznie spadły – szczególnie zauważalne dla autobusów, naczep i ciężarówek.</p>

      <p>🔍 W latach 2022–2023 widzimy symboliczne liczby rejestracji, co może wynikać z:
      <ul>
        <li>ograniczeń administracyjnych,</li>
        <li>trudności z klasyczną rejestracją pojazdów humanitarnych,</li>
        <li>braku spójnych danych w okresie wojennym.</li>
      </ul>
      </p>

      <p>🎯 Celem tej wizualizacji jest uchwycenie dynamiki rynku transportowego w Ukrainie w kontekście geopolitycznym i ekonomicznym.</p>"))),
              tabPanel("Rejestracje motorów i skuterów", plotlyOutput("moto", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                       HTML("<p>Na wykresie przedstawiono <strong>liczbę rejestracji motocykli i skuterów</strong> w Ukrainie w latach <strong>2017–2023</strong>.</p>

      <p>📈 <strong>Motocykle</strong> zyskiwały na popularności do 2021 roku, osiągając rekordowy poziom ponad <strong>70 000</strong> rejestracji.</p>

      <p>🛴 <strong>Skutery</strong>, choć obecne na rynku, nie osiągały tak dużych wartości – w najlepszych latach oscylowały wokół <strong>13–14 tysięcy</strong>.</p>

      <p>⚠️ W latach <strong>2022–2023</strong> liczba rejestracji spadła niemal do zera – szczególnie dramatycznie w przypadku skuterów.
      Może to być konsekwencją wojny, ograniczeń importowych oraz przestawienia się rynku na inne środki transportu.</p>

      <p>🎯 Dane te mogą stanowić podstawę do analizy przyszłości lekkiej mobilności oraz roli jednośladów w czasie kryzysu.</p>"))),
              tabPanel("Średni wiek pojazdów", plotlyOutput("avg_age", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                       HTML("<p>
        Na wykresie zaprezentowano, jak zmieniał się <strong>średni wiek pojazdów zarejestrowanych w Ukrainie</strong> w latach <strong>2017–2023</strong>.
      </p>

      <p>
        📈 W latach 2017–2019 średni wiek stopniowo wzrastał, osiągając poziom powyżej 12 lat.
        Jednak w 2020 roku nastąpił <strong>nagły spadek</strong>, prawdopodobnie spowodowany zwiększonym importem młodszych pojazdów po okresie pandemii.
      </p>

      <p>
        ⚠️ Od 2021 roku obserwujemy <strong>systematyczny wzrost wieku</strong>, sięgający w 2023 roku ponad <strong>13 lat</strong>.
        Wzrost ten może być skutkiem pogarszającej się sytuacji gospodarczej, braku nowych aut na rynku i importu starszych pojazdów używanych.
      </p>

      <p>
        🎯 Kolory punktów na wykresie odzwierciedlają wartość średniego wieku – od <em>ciemnego fioletu (młodsze auta)</em>
        do <em>jasnej żółci (starsze pojazdy)</em>.
      </p>

      <p>
        📌 Rosnący wiek pojazdów ma wpływ na <strong>bezpieczeństwo drogowe</strong>, <strong>środowisko</strong> oraz <strong>koszty utrzymania floty</strong>.
        Wskazuje także na potrzebę działań naprawczych w zakresie polityki transportowej i infrastruktury.
      </p>"))),
              tabPanel("Typy nadwozi", plotlyOutput("bodies", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                       HTML("<p>Powyższy wykres prezentuje <strong>pięć najczęściej rejestrowanych typów nadwozi samochodów osobowych</strong> w Ukrainie w latach <strong>2017–2023</strong>.</p>

      <p>🔷 <strong>Sedany</strong> oraz 🟧 <strong>kombi</strong> utrzymują dominującą pozycję przez cały okres, z rekordem rejestracji kombi w roku <strong>2021 – ponad 920 tys.</strong></p>

      <p>🟩 <strong>Hatchbacki</strong> plasują się na trzecim miejscu, z rejestracjami w granicach <strong>220–370 tys.</strong> rocznie.</p>

      <p>🔺 <strong>Pojazdy pasażerskie</strong>, <strong>towarowo-pasażerskie</strong> i <strong>cupe</strong> pojawiają się sporadycznie i stanowią niszową część rynku.</p>

      <p>📉 Lata <strong>2022–2023</strong> przynoszą drastyczny spadek rejestracji w każdej kategorii — na skutek wojny, ograniczonego importu i wyzwań logistycznych.</p>

      <p>🎯 Wykres ten pozwala przeanalizować zmieniające się preferencje konsumentów i dostarcza wiedzy na temat struktury rynku samochodowego w kontekście zmiennych warunków ekonomicznych i geopolitycznych.</p>"))),
              tabPanel("Rodzaje paliwa", plotlyOutput("fuel_by", height = "630px"), 
                       tags$div(style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;", 
                       HTML("<p>
        Wykres przedstawia <strong>liczbę rejestracji pojazdów według rodzaju paliwa</strong> w Ukrainie w latach <strong>2017–2023</strong>.
      </p>
      <p>🟪 <strong>Benzyna</strong> i 🟦 <strong>diesel</strong> dominowały przez cały analizowany okres. W 2021 roku liczba rejestracji pojazdów benzynowych przekroczyła <strong>1,1 miliona</strong>.</p>
      <p>🟩 <strong>Benzyna z gazem</strong> (LPG) pozostała silną i ekonomiczną alternatywą, z rejestracjami sięgającymi nawet <strong>500 tysięcy</strong> rocznie.</p>
      <p>⚡ <strong>Pojazdy elektryczne</strong> i 🔴 <strong>hybrydowe</strong> zyskiwały na znaczeniu w latach 2019–2021, jednak wciąż stanowią niewielki procent całości.</p>
      <p>📉 Lata <strong>2022–2023</strong> to dramatyczny spadek liczby rejestracji we wszystkich typach paliw — co wiąże się bezpośrednio z wojną, kryzysem importowym i zmianą priorytetów transportowych.</p>
      <p>🎯 Analiza zmian w strukturze paliwowej pomaga zrozumieć kierunki rozwoju mobilności oraz gotowość rynku do transformacji energetycznej.</p>"))),
              
              tabPanel(
                "Import Humanitarny 2022-2023",
                tags$img(
                  src = "https://maksym-nenashev.imgix.net/humanitary.png",
                  style = "width:100%; max-height:630px; object-fit:contain; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.2);"
                ),
                tags$div(
                  style = "font-size:20px; line-height:1.6; margin-top:20px; margin-bottom:20px;",
                  HTML("
      <p>📦 W latach <strong>2022–2023</strong> na Ukrainę sprowadzono ponad <strong>173 000 pojazdów</strong> jako pomoc humanitarna, w tym karetki pogotowia i pojazdy wojskowe.</p>
      <p>🔍 Wiele z nich nie zostało zarejestrowanych w klasycznych bazach policyjnych ze względu na uproszczoną procedurę i warunki wojenne.</p>
      <p>⚠️ Wzrost liczby naruszeń celnych (z 100 do 464) pokazuje, że procedury są nie tylko wykorzystywane legalnie, ale też obchodzone.</p>
    ")))
            )
          )
        )
      ),
      # ---- Prognoza_rejestracji ----
      tabItem(
        tabName = "Prognoza_rejestracji",
        fluidRow(
          sortable(
            width = 12,
            box(
              title = "Regresja liniowa ", 
              width = 12, 
              status = "purple",
              solidHeader = TRUE,
              collapsible = FALSE,
              ribbon(
                text = "R² = 0.159",
                color = "orange"
              ),
              plotlyOutput("REGRESSION", height = "630px"),
              tags$div(style = "padding: 15px 20px;", 
                       HTML("<div style='font-size:20px; line-height:1.6; color:#444444;'>
            <p>
              🔎 Wykres powyżej przedstawia liniową regresję liczby zarejestrowanych pojazdów w Ukrainie w latach 2017–2023. 
              Linia trendu została wyznaczona metodą najmniejszych kwadratów, próbując zobrazować ogólną tendencję zmian w czasie.
            </p>
            <p>
              ❗ Jednakże należy zaznaczyć, że <b>model regresji liniowej w tym przypadku nie oddaje rzeczywistego charakteru danych</b>. 
              R² wynoszące <span style='color:red;'><b>0.159</b></span> oznacza, że tylko 15.9% zmienności danych może być wyjaśnione przez ten model.
            </p>
            <p>
              📉 Tak słabe dopasowanie wynika przede wszystkim z dramatycznego spadku liczby rejestracji po <b>lutym 2022 roku</b>, 
              kiedy rozpoczęła się pełnoskalowa inwazja Rosji na Ukrainę. Dane z lat 2022–2023 są silnie zaburzone przez sytuację wojenną, 
              brak klasycznych procesów rejestracyjnych oraz niedostępność danych dotyczących pojazdów humanitarnych.
            </p>
            <p>
              🧠 W związku z tym, <b>regresja liniowa nie powinna być interpretowana jako prognoza ani wiarygodna miara trendu</b>. 
              W przypadku tego zestawu danych bardziej odpowiednie mogą być modele nieliniowe lub uwzględniające zmienne kontekstowe 
              (np. modele z interwencją lub strukturalne).
            </p>
            <p style='color:#999999; font-size:13px;'>
              * R² – współczynnik determinacji (ang. coefficient of determination)
            </p>
          </div>"))
            ),
            box(
              title = "ARIMA Model",
              width = 12,
              status = "purple",
              solidHeader = TRUE,
              collapsible = FALSE,
              maximizable = TRUE,
              plotlyOutput("arima", height = "630px"),
              tags$div(style = "padding: 15px 20px;", 
                       HTML("<div style='font-size:20px; line-height:1.8; color:#444444;'>
          <p>
            🔮 Powyższy wykres przedstawia prognozę liczby rejestracji pojazdów w Ukrainie na lata <b>2024–2025</b> 
            z wykorzystaniem modelu szeregów czasowych <b>ARIMA</b> (Autoregressive Integrated Moving Average).
          </p>
          <p>
            📈 Na podstawie danych z lat <b>2017–2023</b> model oszacował przyszłe wartości oraz <b>przedział ufności 95%</b>, 
            oznaczony czerwonym pasem. Prognoza sugeruje stabilizację na poziomie około 
            <span style='color:red;'><b>916 217 pojazdów rocznie</b></span>.
          </p>
          <p>
            ❗ Jednakże rzeczywiste dane za rok <b>2024</b> wskazują na znacznie wyższą wartość:
            <span style='color:green; font-weight:bold;'>ponad 2 300 000 rejestracji</span>. 
            To wyraźnie pokazuje, że <b>model ARIMA niedoszacował rzeczywistości</b>, ponieważ nie był w stanie uwzględnić 
            silnych zakłóceń geopolitycznych i dynamicznych zmian po wybuchu wojny.
          </p>
          <p>
            📉 Modele szeregów czasowych, takie jak ARIMA, dobrze sprawdzają się w stabilnym środowisku, ale w warunkach wojennych 
            i humanitarnych migracji danych – <b>ich prognozy należy interpretować ostrożnie</b>.
          </p>
          <p style='color:#999999; font-size:13px;'>
            * Przedział ufności (confidence interval) wskazuje zakres, w którym z 95% pewnością znajdzie się wartość przyszła.
          </p>
        </div>"))
            )
          ),
          fluidRow(
            column(6,
                   box(
                     title = "📊 Udział rejestracji 2024",
                     width = NULL,
                     status = "purple",
                     solidHeader = TRUE,
                     collapsible = FALSE,
                     plotlyOutput("reg_2024", height = "630px")
                   )
            ),
            column(6,
                   box(
                     title = "📘 Komentarz analityczny",
                     width = NULL,
                     status = "info",
                     solidHeader = TRUE,
                     collapsible = FALSE,
                     tags$div(style = "padding: 20px;", 
                     HTML("<div style='font-size:20px; line-height:1.8; color:#2c3e50;'>
          <p>📌 <strong>W 2024 roku</strong> odnotowano rekordową liczbę rejestracji – 
          <span style='color:green; font-weight:bold;'>ponad 2 300 000 pojazdów</span>. 
          To znacznie przewyższa prognozy klasycznych modeli statystycznych.</p>
          
          <p>📉 Modele regresyjne, takie jak <strong>ARIMA</strong>, <strong>nie przewidziały tego wzrostu</strong> 
          z powodu braku uwzględnienia zmian prawnych i szoków systemowych.</p>
          
          <p>🛃 <strong>W 2024 roku zniesiono cła, VAT i akcyzę</strong> na pojazdy używane. 
          Skutkowało to gwałtownym napływem importowanych samochodów i dynamicznym wzrostem rejestracji prywatnych.</p>
          
          <p>⚠️ Wnioski: <strong>prognozowanie wymaga kontekstu</strong> – geopolityka, prawo i zmiany społeczne 
          muszą być częścią analizy, nie tylko dane liczbowe.</p>
          
          <p style='font-size:13px; color:#999;'>* Źródło: dane z rejestrów publicznych Ukrainy data.gov.ua (2024)</p>
        </div>")))
            )
          )
        )
      ),
       # Opis_techniczny---------------------------------------------------------------------------------------------------------
       tabItem(
         tabName = "opis_techniczny",
         fluidRow(
           box(
             title = "📘 Techniczny opis pracy magisterskiej",
             width = 12,
             status = "info",
             solidHeader = TRUE,
             collapsible = TRUE,
             tags$div(
               style = "font-size:18px; line-height:1.7; padding: 20px;",
               HTML("
          <h2 style='color:#2c3e50; font-weight:bold;'>📊 Techniczny opis projektu analitycznego</h2>
          <p>Projekt magisterski realizowany w ramach kierunku <strong>Analiza Danych (WSB-NLU, 2025)</strong> koncentruje się na eksploracji rynku motoryzacyjnego Ukrainy w latach <strong>2017–2023</strong>, z użyciem nowoczesnych narzędzi statystycznych i wizualizacyjnych w języku <code>R</code> i środowisku <code>Shiny</code>.</p>

          <h3 style='color:#2c3e50;'>📂 Źródła danych i przygotowanie</h3>
          <ul>
            <li>Pozyskano <strong>7 dużych plików danych</strong> w formatach <code>CSV</code>, <code>BSV</code> oraz <code>TXT</code>.</li>
            <li>Utworzono <strong>wielowymiarową matrycę danych</strong> (~5 GB) obejmującą informacje o typach pojazdów, kolorach, paliwie, właścicielach, lokalizacjach itp.</li>
            <li>Zrealizowano pełen proces czyszczenia i integracji danych z użyciem <code>dplyr</code>, <code>tidyr</code>, <code>lubridate</code>, <code>janitor</code> i innych pakietów.</li>
          </ul>

          <h3 style='color:#2c3e50;'>⚙️ ETL i optymalizacja danych</h3>
          <ul>
            <li>Wdrożono proces <strong>ETL (Extract – Transform – Load)</strong>, przekształcając dane w zoptymalizowaną strukturę.</li>
            <li>Dane zostały początkowo zapisane jako <code>.fst</code>, co zmniejszyło ich rozmiar z 5 GB do około 1 GB.</li>
            <li>Finalnie użyto formatu <code>.rds</code> dla pełnej kompatybilności z aplikacją <code>Shiny</code>.</li>
          </ul>

          <h3 style='color:#2c3e50;'>📈 Analiza i modelowanie</h3>
          <ul>
            <li>Przeprowadzono <strong>analizy korelacyjne</strong> dla zmiennych czasowych i kategorycznych.</li>
            <li>Zbudowano <strong>regresje liniowe</strong> dla kluczowych wskaźników (rejestracje vs. lata).</li>
            <li>Wykorzystano modele <strong>ARIMA</strong> do prognozowania rejestracji w latach 2024–2025.</li>
            <li>Stworzono wizualizacje interaktywne z użyciem <code>plotly</code> i <code>leaflet</code>.</li>
          </ul>

          <h3 style='color:#2c3e50;'>💡 Wnioski</h3>
          <p>Dzięki zastosowaniu <strong>R</strong> i <strong>Shiny</strong> zespół projektowy stworzył w pełni interaktywny dashboard wspierający eksplorację danych o rynku samochodowym Ukrainy. Projekt łączy zaawansowane przetwarzanie danych, modelowanie i nowoczesny UI, pokazując praktyczne zastosowanie analityki w kontekście realnych zjawisk gospodarczych i społecznych.</p>

          <blockquote style='color:#555; font-style:italic;'>Projekt wykonany przez: <strong>Anna Nenasheva & Maksym Nenashev</strong></blockquote>
        ")
             )
           )
         )
         
       ) # <-- ВОТ ЭТА скобка закрывает tabItem
    ) # <-- ВОТ ЭТА скобка закрывает tabItems
  ), # <-- ВОТ ЭТА скобка закрывает dashboardBody
  
  # Footer -------------------------------------------------------------------------------------------------
  footer = dashboardFooter(
    fluidRow(
      column(
        width = 12,
        div(
          style = "padding: 25px; background-color: #2c3e50; color: white; text-align: center; border-radius: 10px;",
          HTML("
          <img src='https://maksym-nenashev.imgix.net/WSB-NLU.jpeg' 
               style='max-height: 70px; border-radius: 50%; box-shadow: 0 4px 8px rgba(0,0,0,0.3); margin-bottom: 15px;' 
               alt='WSB-NLU logo'>

          <p style='font-size: 18px;'>
            🚗 Projekt zrealizowany jako część pracy magisterskiej kierunku <strong>Analiza Danych</strong> (WSB-NLU, 2025).<br>
            Tematyka: <em>analiza rynku motoryzacyjnego Ukrainy (2017–2023)</em>, z wykorzystaniem <strong>R, Shiny, ETL, regresji, szeregów czasowych, AWS S3</strong>.
          </p>

          <p style='font-size: 14px; color: #cccccc;'>© 2025 Maksym Nenashev & Anna Nenasheva · Wszystkie prawa zastrzeżone</p>
        ")
        )
      )
    )
  ) # <-- закрывает dashboardFooter!
) # <-- UI закрывает dashboardPage!

# Server ------------------------------------------------------------------
server <- function(input, output) {
 #_______ BOX 1  Liczba_rejestracji
  output$Liczba_rejestracji <- renderPlotly({
    
    # 🔁 Загружаем заранее сохранённую таблицу
    #registrations_new_by_year_2 <- readRDS("/home/maks/Документы/Data_frame/RDS/registrations_new_by_year_2.rds")
    registrations_new_by_year_2 <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/registrations_new_by_year_2.rds"))
    
    # 🎨 Цветовая палитра (под 7 лет)
    custom_colour <- viridis::mako(n = 7, direction = -1) # mako, turbo, magma, plasma, inferno, cividis, rocket
    #custom_colour <- viridis::plasma(n = 7, direction = -1)
    
    # === 💅 Шрифты ===
    title_font <- list(family = "Trebuchet MS", size = 26, color = "blue")
    axis_font  <- list(family = "Trebuchet MS", size = 26, color = "red")
    tick_font  <- list(family = "Trebuchet MS", size = 20, color = "#2c3e50")
    
    # === 🌟 Построение графика ===
    plot_ly(registrations_new_by_year_2,
            x = ~factor(ROK_REJESTRACJI),
            y = ~ILOSC,
            type = 'bar',
            marker = list(color = custom_colour,
                          line = list(color = "#2c3e50", width = 1.5)),
            text = ~paste0(ROK_REJESTRACJI, "<br>🚗 ", format(ILOSC, big.mark = " "), " aut"),
            hoverinfo = 'text',
            textposition = 'outside',
            textfont = list(size = 15, color = "#1a1a1a")) %>%
      layout(
        title = list(text = "🚘 Rejestracja Nowych pojazdów na Ukrainie (2017–2023)", font = title_font),
        xaxis = list(title = list(text = "Rok", font = axis_font),
                     tickfont = tick_font,
                     showgrid = FALSE),
        yaxis = list(title = list(text = "Liczba rejestracji", font = axis_font),
                     tickfont = tick_font,
                     showgrid = TRUE,
                     gridcolor = '#dfe6e9'),
        margin = list(t = 90, b = 70),
        plot_bgcolor = "#f0f4f8",
        paper_bgcolor = "#ffffff"
      ) %>%
      config(displayModeBar = FALSE)
  })  
# BOX 1 Block2
  #_______ BOX 2 uzywane_pojazdy
  output$uzywane_pojazdy <- renderPlotly({
    
    # 🔁 Загружаем заранее сохранённую таблицу
    #registrations_new_by_year_3 <- readRDS("/home/maks/Документы/Data_frame/RDS/registrations_new_by_year_3.rds")
    registrations_new_by_year_3 <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/registrations_new_by_year_3.rds"))
    
    # 🎨 Kolory profesjonalne
    colors <- viridis::plasma(n = nrow(registrations_new_by_year_3), direction = -1) # mako, turbo, magma, plasma, inferno, cividis, rocket
    
    # ✍️ Czcionki i styl
    title_font <- list(family = "Segoe UI", size = 28, color = "#1f2d3d")
    axis_font  <- list(family = "Segoe UI", size = 22, color = "#2d3436")
    tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
    
    # 🚘 Rysowanie wykresu
    plot_ly(
      data = registrations_new_by_year_3,
      x = ~factor(ROK_REJESTRACJI),
      y = ~ILOSC,
      type = 'bar',
      marker = list(
        color = colors,
        line = list(color = "#1f2d3d", width = 1)
      ),
      text = ~paste0("<b>", ROK_REJESTRACJI, "</b><br>🚘 ", formatC(ILOSC, format = "d", big.mark = " "), " pojazdów"),
      textposition = 'outside',
      hoverinfo = 'text'
    ) %>%
      layout(
        title = list(text = "Rejestracja Używanych pojazdów na Ukrainie (2017–2023)", font = title_font),
        xaxis = list(title = list(text = "Rok", font = axis_font), tickfont = tick_font),
        yaxis = list(title = list(text = "Liczba pojazdów", font = axis_font),
                     tickfont = tick_font,
                     showgrid = TRUE,
                     gridcolor = '#e0e0e0'),
        margin = list(t = 90, b = 80),
        plot_bgcolor = "#fafafa",
        paper_bgcolor = "#ffffff"
      ) %>%
      config(displayModeBar = FALSE)
  })  
  # BOX 1 Block3
  #_______ BOX 1
  output$new_used <- renderPlotly({
    
    # 🔁 Загружаем заранее сохранённую таблицу
    #data_list <- readRDS("/home/maks/Документы/Data_frame/RDS/aggregated_data_4.rds")
    data_list <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/aggregated_data_4.rds"))
    
    aggregated_data <- data_list$aggregated_data
    new_data        <- data_list$new_data
    used_data       <- data_list$used_data
    total_data      <- data_list$total_data
    
    # 🎨 Цвета
    colors <- c("Nowy pojazd" = "#1f77b4", "Używany pojazd" = "pink", "Ogółem" = "#2ecc71")
    
    # ✍️ Шрифты
    title_font <- list(family = "Segoe UI", size = 26, color = "red")
    axis_font  <- list(family = "Segoe UI", size = 20, color = "blue")
    tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
    
    # === 🚘 Построение графика
    plot_ly() %>%
      add_trace(
        data = new_data,
        x = ~factor(ROK_REJESTRACJI),
        y = ~ILOSC,
        type = 'bar',
        name = "Nowe pojazdy",
        marker = list(color = colors["Nowy pojazd"]),
        text = ~paste0("🚘 ", formatC(ILOSC, format = "d", big.mark = " ")),
        textposition = 'outside',
        textfont = list(size = 18, color = "#1a1a1a"),
        hoverinfo = 'text'
      ) %>%
      add_trace(
        data = used_data,
        x = ~factor(ROK_REJESTRACJI),
        y = ~ILOSC,
        type = 'bar',
        name = "Pojazdy używane",
        marker = list(color = colors["Używany pojazd"]),
        text = ~paste0("🚙 ", formatC(ILOSC, format = "d", big.mark = " ")),
        textposition = 'outside',
        textfont = list(size = 18, color = "#1a1a1a"),
        hoverinfo = 'text'
      ) %>%
      add_trace(
        data = total_data,
        x = ~factor(ROK_REJESTRACJI),
        y = ~ILOSC_OFFSET,  # 👈 линия поднята
        type = 'scatter',
        mode = 'lines+markers',
        name = "Ogółem",
        line = list(color = colors["Ogółem"], width = 3),
        marker = list(size = 8),
        hoverinfo = 'text',
        hovertext = ~paste0("📊 ", formatC(ILOSC, format = "d", big.mark = " "))  # ← тут была ошибка
    ) %>%
      add_trace(
        data = total_data,
        x = ~factor(ROK_REJESTRACJI),
        y = ~ILOSC_LABEL,  # ⬆️ подписи ещё выше
        type = 'scatter',
        mode = 'text',
        text = ~paste0("📊 ", formatC(ILOSC, format = "d", big.mark = " ")),
        textfont = list(size = 16, color = "#2ecc71"),
        showlegend = FALSE,
        hoverinfo = "none"
      ) %>%
      layout(
        barmode = "group",
        bargap = 0.05,
        title = list(text = "📊 Rejestracja pojazdów: nowe, używane i ogółem (2017–2023)", font = title_font),
        xaxis = list(title = list(text = "Rok", font = axis_font), tickfont = tick_font),
        yaxis = list(title = list(text = "Liczba pojazdów", font = axis_font), tickfont = tick_font),
        legend = list(x = 0.75, y = 0.95),
        plot_bgcolor = "#fafafa",
        paper_bgcolor = "#ffffff",
        margin = list(t = 80, b = 60)
      ) %>%
      config(displayModeBar = FALSE)
  })  
  # BOX 1 Block4
  output$priwat <- renderPlotly({
  # 🔁 Загружаем заранее сохранённую таблицу
    #ownership_by_year <- readRDS("/home/maks/Документы/Data_frame/RDS/ownership_by_year_6.rds")
    ownership_by_year <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/ownership_by_year_6.rds"))
    
    owner_colors <- c("Prywatny" = "#2ecc71", "Inny" = "#e74c3c")
    font_big <- list(family = "Trebuchet MS", size = 24, color = "red")
    font_ticks <- list(family = "Trebuchet MS", size = 18, color = "blue")
    
    plot_ly(ownership_by_year,
            x = ~factor(ROK_REJESTRACJI),
            y = ~ILOSC,
            type = 'bar',
            color = ~OWNER_TYPE,
            colors = owner_colors,
            text = ~formatC(ILOSC, format = "d", big.mark = " "),
            textposition = "outside",
            texttemplate = "%{text}",
            textfont = list(size = 14, color = "#000000"),
            hoverinfo = 'text',
            hovertext = ~paste0(OWNER_TYPE, ": ", formatC(ILOSC, format = "d", big.mark = " "))) %>%
      layout(
        title = list(text = "🚘 Rejestracje prywatne i inne (2017–2023)", font = font_big),
        xaxis = list(title = list(text = "Rok", font = font_big),
                     tickfont = font_ticks,
                     tickangle = -30),
        yaxis = list(title = list(text = "Liczba rejestracji", font = font_big),
                     tickfont = font_ticks,
                     rangemode = "tozero"),
        barmode = 'group',
        bargap = 0.25,
        uniformtext = list(minsize = 12, mode = 'show'),
        legend = list(title = list(text = "Typ właściciela", font = font_ticks)),
        margin = list(t = 100, b = 100),
        plot_bgcolor = "#f9f9f9",
        paper_bgcolor = "#ffffff"
        # width и height не нужны — адаптация работает автоматически
      ) %>%
      config(displayModeBar = FALSE)
  })
  # BOX 1 Block5____________________________________________________________________________
  output$top_colors_by_year <- renderPlotly({
     
    # 🔁 Загружаем заранее сохранённую таблицу
    #top_colors <- readRDS("/home/maks/Документы/Data_frame/RDS/top_colors_7.rds")
    top_colors <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/top_colors_7.rds"))
    
    # ✍️ Czcionki
    title_font <- list(family = "Segoe UI", size = 26, color = "red")
    axis_font  <- list(family = "Segoe UI", size = 23, color = "blue")
    tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
    
    # === 📈 Построение графика (через цикл)
    fig <- plot_ly()
    
    for (col_name in unique(top_colors$COLOR)) {
      df <- filter(top_colors, COLOR == col_name)
      
      # 👇 Условие по серому цвету и году
      text_pos <- if (col_name == "СІРИЙ") {
        ifelse(df$ROK_REJESTRACJI %in% c(2022, 2023), "outside", "inside")
      } else {
        rep("outside", nrow(df))
      }
      
      fig <- fig %>%
        add_trace(
          data = df,
          x = ~factor(ROK_REJESTRACJI),
          y = ~ILOSC,
          type = "bar",
          name = df$COLOR_LABEL[1],
          marker = list(
            color = df$COLOR_PLOT[1],
            line = list(
              color = df$LINE_COLOR[1],
              width = df$LINE_WIDTH[1]
            ),
            opacity = 0.95
          ),
          text = ~LABEL,
          textposition = text_pos,  # 👈 вот тут логика
          textposition = ~ifelse(COLOR == "СІРИЙ" & ROK_REJESTRACJI %in% c(2022, 2023), "inside", "outside"),
          textangle = -90,
          textfont = list(color = "#2d3436", size = 14, family = "Segoe UI", bold = TRUE),
          hoverinfo = 'text',
          hovertext = ~paste0(df$COLOR_LABEL, ": ", LABEL)
        )
    }
    
    # === 🎨 Финальная стилизация
    fig %>%
      layout(
        title = list(text = "🎨 Top 5 kolorów samochodów wg roku (2017–2023)", 
                     font = title_font,
                     y = 0.98,   # ⬇️ Опущен ниже
                     x = 0.5),
        xaxis = list(
          title = list(text = "Rok rejestracji", font = axis_font),
          tickfont = tick_font
        ),
        yaxis = list(
          title = list(text = "Liczba rejestracji", font = axis_font),
          tickfont = tick_font
        ),
        barmode = "group",
        bargap = 0.25,
        plot_bgcolor = "#f9f9f9",
        paper_bgcolor = "#ffffff",
        uniformtext = list(minsize = 10, mode = 'show'),
        legend = list(title = list(text = "Kolor"))
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # BOX 1 Block6____________________________________________________________________________
  output$med_cars <- renderPlotly({
    
    # 🔁 Загружаем заранее сохранённую таблицу
    #cars_medyczny <- readRDS("/home/maks/Документы/Data_frame/RDS/cars_medyczny_10.rds")
    cars_medyczny <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/cars_medyczny_10.rds"))
    
    #title_font <- list(family = "Segoe UI", size = 26, color = "red")
    axis_font  <- list(family = "Segoe UI", size = 23, color = "blue")
    tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
    
    # === 📈 Построение графика
    fig_medyczny <- plot_ly()
    
    fig_medyczny <- fig_medyczny %>%
      add_trace(
        data = cars_medyczny,
        x = ~factor(ROK_REJESTRACJI),
        y = ~ILOSC,
        type = "bar",
        name = "Transport medyczny",
        marker = list(color = "#e74c3c"),
        text = ~formatC(ILOSC, format = "d", big.mark = " "),
        textposition = "outside",
        textangle = -90,
        insidetextanchor = "start",
        cliponaxis = FALSE,
        textfont = list(size = 16, color = "black"),
        hovertext = ~LABEL,
        hoverinfo = "text",
        width = 0.8
      )
    
    # === 🎨 Оформление
    fig_medyczny <- fig_medyczny %>%
      layout(
        title = list(
          text = "🚑 Rejestracje transportu medycznego (2017–2023)",
          font = list(family = "Segoe UI", size = 26, color = "blue"),
          x = 0.5,
          y = 0.99
        ),
        xaxis = list(
          title = list(text = "Rok rejestracji", font = axis_font),
          tickfont = list(size = 14),
          tickangle = -30
        ),
        yaxis = list(
          title = list(text = "Liczba rejestracji", font = axis_font),
          tickfont = list(size = 14)
        ),
        legend = list(
          title = list(text = "Typ pojazdu"),
          font = list(size = 14)
        ),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "#ffffff",
    
        fig_medyczny
    ) %>%
      config(displayModeBar = FALSE)
  })
  
  #Dashbord number_2 Plot 1______________________________________________________________________________________
  output$Top_3 <- renderPlotly({
    # 🔁 Загружаем заранее сохранённую таблицу
    #top3 <- readRDS("/home/maks/Документы/Data_frame/RDS/top3_5.rds")
    top3 <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/top3_5.rds"))
    
    # === 🎨 Цвета и шрифты
    top_colors <- viridis::plasma(length(unique(top3$BRAND)))
    font_big <- list(family = "Trebuchet MS", size = 24, color = "red")
    font_ticks <- list(family = "Trebuchet MS", size = 18, color = "blue")
    
    # === 📊 График
    plot_ly(top3,
            x = ~factor(ROK_REJESTRACJI),
            y = ~ILOSC,
            type = 'bar',
            color = ~BRAND,
            colors = top_colors,
            text = ~TEXT_LABEL,          # 👈 используем HTML-текст
            textposition = ~TEXT_POS,
            hoverinfo = 'text',
            textangle = -90,  # 👈 вот это — чтобы ВЕЗДЕ было вертикальн
            hovertext = ~paste0(BRAND, ": ", formatC(ILOSC, format = "d", big.mark = " ")),
            texttemplate = "%{text}",    # 👈 важно для отображения HTML
            hoverlabel = list(font = list(size = 14))
    ) %>%
      layout(
        title = list(text = "🏆 Top 3 marki w każdym roku (2017–2023)", font = font_big),
        xaxis = list(title = list(text = "Rok", font = font_big),
                     tickfont = font_ticks,
                     tickangle = -30),
        yaxis = list(title = list(text = "Liczba rejestracji", font = font_big),
                     tickfont = font_ticks,
                     rangemode = "tozero"),
        barmode = 'group',
        bargap = 0.2,
        uniformtext = list(minsize = 14, mode = 'show'),
        legend = list(title = list(text = "Marka", font = font_ticks)),
        margin = list(t = 100, b = 120),
        plot_bgcolor = "#f5f6fa",
        paper_bgcolor = "#ffffff",
        width = 1200,
        height = 700
      ) %>%
      config(displayModeBar = FALSE)
  })
  #//////////////////////////////////////////////////////////////////////////////////////////////////////
   
  #Dashbord number_2 Plot 2__________________________________________________________________________________
   output$fig <- renderPlotly({
     
     # 🔁 Загружаем заранее сохранённую таблицу
     #data_main <- readRDS("/home/maks/Документы/Data_frame/RDS/data_main_8.rds")
     data_main <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/data_main_8.rds"))
     
     # === 🚙 Основные категории
     main_types <- c("ЛЕГКОВИЙ", "ВАНТАЖНИЙ", "АВТОБУС", "ПРИЧІП", "НАПІВПРИЧІП")
     
     # === Перевод KIND на польский + цвета
     kinds_info <- tibble(
       KIND = main_types,
       KIND_PL = c("Samochód osobowy", "Ciężarowy", "Autobus", "Przyczepa", "Naczepa"),
       COLOR = c("#4daf4a", "#377eb8", "#ff7f00", "#984ea3", "red")
     )
     
     # ✍️ Czcionki
     title_font <- list(family = "Segoe UI", size = 26, color = "red")
     axis_font  <- list(family = "Segoe UI", size = 23, color = "blue")
     tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
     
     # === 📈 Построение графика
     fig_main <- plot_ly()
     
     for (i in seq_len(nrow(kinds_info))) {
       kind_row <- kinds_info[i, ]
       df <- filter(data_main, KIND == kind_row$KIND)
       
       if (nrow(df) > 0) {
         fig_main <- fig_main %>%
           add_trace(
             data = df,
             x = ~factor(ROK_REJESTRACJI),
             y = ~ILOSC,
             type = "bar",
             name = kind_row$KIND_PL,
             marker = list(color = kind_row$COLOR),
             text = ~formatC(ILOSC, format = "d", big.mark = " "),
             textposition = "outside",
             textangle = -90,  # ← вертикально
             insidetextanchor = "start",  # 🧠 предотвращает смещение текста внутрь
             cliponaxis = FALSE,          # 🔥 позволяет тексту выходить за оси
             textfont = list(size = 16, color = "black"),  # ← фиксированный размер
             hovertext = ~LABEL,
             hoverinfo = "text",
             width = 0.25
           )
       }
     }
     
     # === 🎨 Оформление
     fig_main <- fig_main %>%
       layout(
         title = list(
           text = "🚗 Rejestracje głównych typów pojazdów (2017–2023)",
           font = title_font,
           y = 0.98,
           x = 0.5
         ),
         barmode = "group",
         xaxis = list(
           title = list(text = "Rok rejestracji", font = axis_font),
           tickfont = tick_font,
           tickangle = -30
         ),
         yaxis = list(
           title = list(text = "Liczba rejestracji", font = axis_font),
           tickfont = tick_font
         ),
         legend = list(
           title = list(text = "Typ pojazdu", font = axis_font),
           font = list(size = 15)
         ),
         plot_bgcolor = "#f8f9fa",
         paper_bgcolor = "#ffffff"
        #fig_main
         ) %>%
       config(displayModeBar = FALSE)
   })
   #Dashbord number_2 Plot 3____________________________________________________________________________________
    output$moto <- renderPlotly({
     # 🔁 Загружаем заранее сохранённую таблицу
    #data_extra <- readRDS("/home/maks/Документы/Data_frame/RDS/data_extra_9.rds")
    data_extra <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/data_extra_9.rds"))
    
    # === 🛵 Категории для второго графика
    extra_types <- c("МОПЕД", "МОТОЦИКЛ")
    
    # === Названия на польском + цвета
    extra_kinds_info <- tibble(
      KIND = extra_types,
      KIND_PL = c("Skutery", "Motory"),
      COLOR = c("#9b59b6", "#2ecc71")
    )
    
    # === 📐 Шрифты
    title_font <- list(family = "Segoe UI", size = 26, color = "red")
    axis_font  <- list(family = "Segoe UI", size = 22, color = "blue")
    tick_font  <- list(family = "Segoe UI", size = 15, color = "#636e72")
     # === 📈 Построение графика
     fig_extra <- plot_ly()
     
     for (i in seq_len(nrow(extra_kinds_info))) {
       kind_row <- extra_kinds_info[i, ]
       df <- filter(data_extra, KIND == kind_row$KIND)
       
       if (nrow(df) > 0) {
         fig_extra <- fig_extra %>%
           add_trace(
             data = df,
             x = ~factor(ROK_REJESTRACJI),
             y = ~ILOSC,
             type = "bar",
             name = kind_row$KIND_PL,
             marker = list(color = kind_row$COLOR),
             text = ~formatC(ILOSC, format = "d", big.mark = " "),
             textposition = "outside",
             textangle = -90,
             cliponaxis = FALSE,
             insidetextanchor = "start",
             textfont = list(size = 16, color = "black"),
             hovertext = ~LABEL,
             hoverinfo = "text",
             width = 0.40
           )
       }
     }
     
     # === 🎨 Оформление
     fig_extra <- fig_extra %>%
       layout(
         title = list(
           text = "🛵 Rejestracje motorow i skuterow (2017–2023)",
           font = title_font,
           x = 1.8,
           y = 0.98
         ),
         barmode = "group",
         xaxis = list(
           title = list(text = "Rok rejestracji", font = axis_font),
           tickfont = tick_font,
           tickangle = -30
         ),
         yaxis = list(
           title = list(text = "Liczba rejestracji", font = axis_font),
           tickfont = tick_font
         ),
         legend = list(
           title = list(text = "Typ pojazdu", font = axis_font),
           font = list(size = 15)
         ),
         plot_bgcolor = "#f8f9fa",
         paper_bgcolor = "#ffffff"
         ) %>%
       config(displayModeBar = FALSE)
   })
    #Dashbord number_2 Plot 4_____________________________________________________________________________________
    output$avg_age <- renderPlotly({
      # 🔁 Загружаем заранее сохранённую таблицу
      #avg_age_data <- readRDS("/home/maks/Документы/Data_frame/RDS/avg_age_11.rds")
      avg_age_data <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/avg_age_11.rds"))
      
      # 🎨 Цветовая палитра и стили
      title_font <- list(family = "Segoe UI", size = 26, color = "#2c3e50")
      axis_font  <- list(family = "Segoe UI", size = 22, color = "#34495e")
      tick_font  <- list(family = "Segoe UI", size = 18, color = "red")
      
      # 📈 График
      plot_ly(
        data = avg_age_data,
        x = ~ROK_REJESTRACJI,
        y = ~AVG_AGE,
        type = "scatter",
        mode = "lines+markers",
        text = ~paste("📆 Rok:", ROK_REJESTRACJI, "<br>🧓 Średni wiek:", round(AVG_AGE, 1), "lat"),
        hoverinfo = "text",
        line = list(shape = "spline", width = 4, color = "#2980b9"),  # Плавная линия
        marker = list(
          size = 14,
          color = ~AVG_AGE,
          colorscale = "Viridis",
          showscale = TRUE,
          colorbar = list(title = "Śr. wiek (lat)")
        )
      ) %>%
        layout(
          title = list(
            text = "📊 Średni wiek wszystkich zarejestrowanych pojazdów (2017–2023)",
            font = title_font,
            x = 0.5,
            y = 0.95
          ),
          xaxis = list(
            title = list(text = "Rok rejestracji", font = axis_font),
            tickfont = tick_font
          ),
          yaxis = list(
            title = list(text = "Średni wiek pojazdu (lata)", font = axis_font),
            tickfont = tick_font
          ),
          plot_bgcolor = "#f8f9fa",
          paper_bgcolor = "#ffffff",
          margin = list(l = 80, r = 60, b = 80, t = 90)
        ) %>%
        config(displayModeBar = FALSE)
    })
   
    #Dashbord number_2 Plot 5_____________________________________________________________________________________
    output$bodies <- renderPlotly({
      
      # 🔁 Загружаем заранее сохранённую таблицу
      #top_bodies <- readRDS("/home/maks/Документы/Data_frame/RDS/top_bodies_12.rds")
      top_bodies <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/top_bodies_12.rds"))
      
      # ✍️ Czcionki
      title_font <- list(family = "Segoe UI", size = 26, color = "red")
      axis_font  <- list(family = "Segoe UI", size = 23, color = "blue")
      tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
      
      # === 📈 Budowa wykresu
      fig_odies <- plot_ly()
      
      for (body_type in unique(top_bodies$BODY)) {
        df <- filter(top_bodies, BODY == body_type)
        
        # 🔁 Условная позиция текста: внутри — если значение большое, иначе — снаружи
        text_pos <- ifelse(df$ILOSC > 50000, "inside", "outside")
        
        fig_odies <- fig_odies %>%
          add_trace(
            data = df,
            x = ~factor(ROK_REJESTRACJI),
            y = ~ILOSC,
            type = "bar",
            name = body_type,
            text = ~LABEL,
            textposition = text_pos,  # 👈 адаптивно
            textangle = -90,  # 👈 вот это — чтобы ВЕЗДЕ было вертикальн
            hoverinfo = "text",
            hovertext = ~paste0(
              "🚗 Typ nadwozia: ", BODY, "<br>",
              "📅 Rok: ", ROK_REJESTRACJI, "<br>",
              "🔢 Liczba: ", LABEL
            ),
            textfont = list(
              size = 16,
              color = ifelse(text_pos == "inside", "white", "black"),
              family = "Segoe UI"
            ),
            marker = list(opacity = 0.95)
          )
      }
      
      
      fig_odies %>%
        layout(
          title = list(
            text = "🏆 Top-5 typów nadwozi samochodów osobowych wg (2017-2023) roku",
            x = 0.5,
            y = 0.97,
            font = title_font
          ),
          xaxis = list(
            title = list(text = "Rok rejestracji", font = axis_font),
            tickfont = tick_font
          ),
          yaxis = list(
            title = list(text = "Liczba rejestracji", font = axis_font),
            tickfont = tick_font
          ),
          barmode = "group",
          bargap = 0.05,
          plot_bgcolor = "#f9f9f9",
          paper_bgcolor = "#ffffff",
          legend = list(title = list(text = "Typ nadwozia")),
          
          # ✅ Управляем всеми подписями
          uniformtext = list(
            minsize = 16,    # Увеличенный шрифт
            mode = 'show'   # Показывать даже если не влезает
         )) %>%
        config(displayModeBar = FALSE)
    })
    
    #Dashbord number_2 Plot 6____________________________________________________________________________________
    output$fuel_by <- renderPlotly({
      # 🔁 Загружаем заранее сохранённую таблицу
      #fuel_by_year <- readRDS("/home/maks/Документы/Data_frame/RDS/fuel_by_year_14.rds") 
      fuel_by_year <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/fuel_by_year_14.rds"))
      
      # === 🎨 Цвета
      fuel_colors <- viridis::turbo(length(unique(fuel_by_year$FUEL_PL)))
      names(fuel_colors) <- unique(fuel_by_year$FUEL_PL)
      
      # === ✍️ Шрифты
      title_font <- list(family = "Segoe UI", size = 26, color = "red")
      axis_font  <- list(family = "Segoe UI", size = 23, color = "blue")
      tick_font  <- list(family = "Segoe UI", size = 16, color = "#636e72")
      
      # === 📈 График
      fig <- plot_ly()
      
      for (fuel in unique(fuel_by_year$FUEL_PL)) {
        df <- filter(fuel_by_year, FUEL_PL == fuel)
        
        fig <- fig %>%
          add_trace(
            data = df,
            x = ~factor(ROK_REJESTRACJI),
            y = ~ILOSC,
            type = "bar",
            name = fuel,
            marker = list(color = fuel_colors[fuel]),
            text = ~LABEL,
            textposition = ~ifelse(ILOSC > 50000, "inside", "outside"),
            textangle = -90,
            textfont = list(size = 14),
            hoverinfo = "text",
            hovertext = ~paste0("🛢 ", fuel, "<br>📅 Rok: ", ROK_REJESTRACJI, "<br>🔢 Liczba: ", LABEL)
          )
      }
      
      # === 🖼️ Финальная стилизация
      fig %>%
        layout(
          title = list(
            text = "🛢 Najpopularniejsze rodzaje paliwa wg roku (2017–2023)",
            font = title_font,
            x = 0.5,
            y = 0.97
          ),
          xaxis = list(title = list(text = "Rok rejestracji", font = axis_font), tickfont = tick_font),
          yaxis = list(title = list(text = "Liczba rejestracji", font = axis_font), tickfont = tick_font),
          barmode = "group",
          # 💥 Уменьшаем расстояние между столбцами → столбцы толще
          bargap = 0.01,   # ← было, можно уменьшить до 0.01 или даже 0
          plot_bgcolor = "#f9f9f9",
          paper_bgcolor = "#ffffff",
          legend = list(title = list(text = "Rodzaj paliwa")),
          uniformtext = list(minsize = 16, mode = 'show')
        ) %>%
         config(displayModeBar = FALSE)
    })
      
   # Dasborg 2 The End
  #/////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
    # 3 REGRESSION______ Dasborg 3______________________________________________________
    output$REGRESSION <- renderPlotly({
      
      #data_list <- readRDS("/home/maks/Документы/Data_frame/RDS/aggregated_data_4.rds")
      data_list <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/aggregated_data_4.rds"))
      total_data <- data_list$total_data
      
      # Приведение года к числу
      total_data <- total_data %>%
        mutate(ROK_REJESTRACJI = as.numeric(as.character(ROK_REJESTRACJI)))
      
      # Линейная модель
      model <- lm(ILOSC ~ ROK_REJESTRACJI, data = total_data)
      
      # Предсказание
      total_data <- total_data %>%
        mutate(PREDICTED = predict(model, newdata = total_data))
      
      # График
      fig <- plot_ly(
        data = total_data,
        x = ~ROK_REJESTRACJI,
        y = ~ILOSC,
        type = "scatter",
        mode = "markers+text",  # ✅ показываем подписи
        name = "Rejestracje rzeczywiste",
        marker = list(color = "#2c3e50", size = 10),
        text = ~paste(formatC(ILOSC, format = "d", big.mark = " ")),
        textposition = "bottom center",  # или "bottom center", "middle right"
        textfont = list(size = 11, color = "black"), # размер подписи
        hoverinfo = "text"
      ) %>%
        add_trace(
          x = ~ROK_REJESTRACJI,
          y = ~PREDICTED,
          type = "scatter",
          mode = "lines",
          line = list(color = "rgba(230,126,34,0.8)", width = 4),  # Прозрачная линия
          name = paste0("📉 Linia regresji (R² = ", round(summary(model)$r.squared, 3), ")"),
          hoverinfo = "skip"
        ) %>%
        layout(
          title = list(
            text = "<b><br>📉 Liniowa regresja: Liczba wszystkich rejestracji (2017–2023)</b>",
            x = 0.5,
            font = list(size = 24, color = "blue")
          ),
          annotations = list(
            list(
              x = 2022,
              y = max(total_data$ILOSC) * 0.75, # Опустить ниже
              text = "🟥 Początek wojny<br><b>Luty 2022</b>",
              showarrow = TRUE,
              arrowhead = 2,
              ax = 0,
              ay = -40,
              font = list(size = 13, color = "red"),
              bgcolor = "#ffeaea",
              bordercolor = "red",
              borderwidth = 1
            ),
            list(
              x = 2022,
              y = 350000, # Опустить ниже
              text = "📉 Spadek wynika z wojny<br>i braku klasycznej rejestracji pojazdów humanitarnych",
              showarrow = FALSE,
              font = list(size = 14),
              align = "center",
              bgcolor = "#fefefe",
              bordercolor = "#d63031",
              borderwidth = 1
            )
          ),
          shapes = list( # Red Line
            list(
              type = "line",
              x0 = 2021.5,
              x1 = 2021.5,
              y0 = 0,
              y1 = max(total_data$ILOSC),
              line = list(color = "red", dash = "dash", width = 2)
            )
          ),
          xaxis = list(
            title = list(text = "🗓 Rok rejestracji", font = list(size = 20, color = "blue")),
            tickfont = list(size = 15, color = "#636e72"),
            tickmode = "linear",
            dtick = 1
          ),
          yaxis = list(
            title = list(text = "🚗 Łączna liczba pojazdów", font = list(size = 20, color = "blue")),
            tickfont = list(size = 15, color = "#636e72")
          ),
          legend = list(
            orientation = "h",
            x = 0.5,
            y = -0.2,
            xanchor = "center",
            font = list(size = 18, color = "#1e272e", family = "Segoe UI")
          )
        ) %>%
        config(displayModeBar = FALSE)
    })
    # Regression ARIMA________________________________________________________________________________________
    output$arima <- renderPlotly({
      
      # === 🔁 Чтение данных
      #data_list <- readRDS("/home/maks/Документы/Data_frame/RDS/aggregated_data_4.rds")
      data_list <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/aggregated_data_4.rds"))
      
      # === 📁 Таблицы
      total_data <- data_list$total_data
      
      # === 🔮 ARIMA
      ts_total <- ts(total_data$ILOSC, start = min(total_data$ROK_REJESTRACJI), frequency = 1)
      model <- auto.arima(ts_total)
      forecast_result <- forecast(model, h = 2)
      
      # === 📊 Подготовка
      forecast_df <- data.frame(
        ROK_REJESTRACJI = 2024:2025,
        ILOSC = as.numeric(forecast_result$mean),
        LOWER = as.numeric(forecast_result$lower[, 2]),
        UPPER = as.numeric(forecast_result$upper[, 2])
      )
      
      # === Объединение
      total_plot_data <- total_data %>%
        select(ROK_REJESTRACJI, ILOSC) %>%
        mutate(TYPE = "Rzeczywiste") %>%
        bind_rows(forecast_df %>% mutate(TYPE = "Prognoza"))
      
      # === 🎨 Цвета
      color_actual <- "#2ecc71"
      color_forecast <- "#e74c3c"
      
      # === 📈 Финальный график (ggplot2 -> plotly)
      ggplot_obj <- ggplot(total_plot_data, aes(x = ROK_REJESTRACJI, y = ILOSC, color = TYPE)) +
        geom_line(size = 1.8) +
        geom_point(size = 4) +
        
        geom_ribbon(
          data = forecast_df,
          aes(x = ROK_REJESTRACJI, ymin = LOWER, ymax = UPPER),
          inherit.aes = FALSE,
          alpha = 0.15,
          fill = color_forecast
        ) +
        
        geom_text(
          aes(label = format(ILOSC, big.mark = " ")),
          #vjust = -2, # 👈 вот этот параметр отвечает за "высоту"
          nudge_y = 100000,
          size = 4.5,
          show.legend = FALSE
        ) +
        
        geom_vline(xintercept = 2022, linetype = "dashed", color = "gray40", linewidth = 0.7) +
        annotate("text", x = 2022, y = max(total_plot_data$ILOSC) * 0.95, label = "Początek wojny", 
                 color = "gray40", size = 4, angle = 90, vjust = -0.5) +
        
        scale_color_manual(values = c("Rzeczywiste" = color_actual, "Prognoza" = color_forecast)) +
        scale_x_continuous(breaks = 2017:2025, limits = c(2017, 2025)) +
        
        labs(
          title = "📈 Prognoza rejestracji pojazdów w Ukrainie na lata 2024–2025 (model ARIMA)",
          subtitle = "Z użyciem danych z lat 2017–2023 oraz prognozą z przedziałem ufności (95%)",
          x = "Rok",
          y = "Liczba pojazdów"
        ) +
        theme(
          plot.title = element_text(face = "bold", size = 18, color = "blue", hjust = 0.5),
          plot.subtitle = element_text(size = 13, color = "red", hjust = 0.5),
          axis.title = element_text(size = 16, color = "blue"),
          axis.text = element_text(size = 12),
          legend.position = "bottom"
        )
      
      # === 🔄 Конвертация в plotly
      ggplotly(ggplot_obj) %>%
        config(displayModeBar = FALSE)
    })
  
 # Sightings by location --- Наблюдения за местоположением  3-й Вверху
  output$reg_2024 <- renderPlotly({
    
    # === 🔁 Чтение данных
    #Fig <- readRDS("/home/maks/Документы/Data_frame/RDS/Fig_15.rds")
    Fig <- readRDS(url("https://imgixshiny.s3.eu-north-1.amazonaws.com/WSB/RDS/Fig_15.rds"))
    
    total_registrations <- sum(Fig$n)
    total_label <- paste0(
      "<span style='font-size:22px; color:blue;'>",
      "🚘 Łączna liczba rejestracji za 2024 rok<br><br>",
      "</span>",
      "<span style='font-size:23px; color:red;'>",
      formatC(total_registrations, format = "d", big.mark = " "),
      " pojazdów",
      "</span>"
    )
    
    # 🖼️ Wykres kołowy
    fig <- plot_ly(
      Fig,
      labels = ~OWNER_TYPE,
      values = ~n,
      type = 'pie',
      textinfo = 'label+percent',
      insidetextorientation = 'radial',
      text = ~hover_text,
      hoverinfo = 'text',
      marker = list(colors = c('#FF6F61', '#6B5B95'))
    ) %>%
      layout(
        title = list(
          text = total_label,
          x = 0.5,
          y = 0.96,
          xanchor = 'center',
          yanchor = 'top'
        ),
        showlegend = TRUE,
        legend = list(title = list(text = "Typ właściciela")),
        margin = list(t = 80),
        paper_bgcolor = "#ffffff",
        plot_bgcolor = "#f9f9f9"
      ) %>%
      config(displayModeBar = FALSE)
    fig
    })
  
  }

shinyApp(ui, server)
