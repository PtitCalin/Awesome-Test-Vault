#!/bin/bash

# -----------------------------------------------------------------------------------
# 🧠 Awesome Test Vault - Personal Encyclopedia Structure Builder
# -----------------------------------------------------------------------------------
# USAGE:
#   ./structure-builder_Personal-Encyclopedia.bash             # Normal mode
#   ./structure-builder_Personal-Encyclopedia.bash --dry-run   # Preview mode
# -----------------------------------------------------------------------------------

# === Configuration ===
VAULT_PATH="/c/Users/charl/OneDrive/Projets/Awesome Test/System/Awesome-Test-Vault"
NOTES_ROOT="$VAULT_PATH/Notes/Personal Encyclopedia"

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🧪 DRY-RUN mode enabled. No changes will be made."
fi

if [ ! -d "$VAULT_PATH" ]; then
  echo "❌ Vault path not found: $VAULT_PATH"
  exit 1
fi

# === Helper Functions ===
create_markdown_pair() {
  local folderpath="$1"
  local name="$2"
  local tag="$3"
  local parent="$4"

  if $DRY_RUN; then
    echo "[DRY RUN] Would create: $folderpath/$name.md"
    echo "[DRY RUN] Would create: $folderpath/Intro to $name.md"
  else
    mkdir -p "$folderpath"
    cat <<EOF > "$folderpath/$name.md"
---
title: "$name"
created: $(date +%Y-%m-%d)
type: $tag
tags: [$tag]
parent: "$parent"
children: []
---

# $name

This is the **$name** section of the $parent.
EOF
    cat <<EOF > "$folderpath/Intro to $name.md"
---
title: "Intro to $name"
created: $(date +%Y-%m-%d)
type: note
tags: [note, $name]
parent: "$name"
children: []
---

# Intro to $name

This note introduces the topic of **$name** within the broader $parent context.
EOF
    echo "📄 Created: $folderpath/$name.md and Intro to $name.md"
  fi
}

# === Generate Structure Recursively ===
create_structure_from_map() {
  local base_path="$1"
  local parent="$2"
  declare -n MAP=$3

  for topic in "${!MAP[@]}"; do
    topic_path="$base_path/$topic"
    create_markdown_pair "$topic_path" "$topic" "topic" "$parent"

    IFS='|' read -ra subtopics <<< "${MAP[$topic]}"
    for subtopic in "${subtopics[@]}"; do
      sub_path="$topic_path/$subtopic"
      create_markdown_pair "$sub_path" "$subtopic" "note" "$topic"
  done
}

# === Full Encyclopedia Structure ===
# === Define Domain Maps ===
declare -A TOPICS
TOPICS=(
  ["Arts & Culture"]="Built & Decorative Arts|Visual Arts|Performing Arts|Literary Arts|Meta-Arts (Theory, Systems, Institutions)"
  ["Economics & Business"]="Microeconomics|Macroeconomics|Behavioral Economics|Entrepreneurship & Startups|Business Strategy"
  ["Geography & Environment"]="Earth Systems|Human Geography|Climate & Biomes|Environmental Sustainability|Disaster Resilience"
  ["Health & Medicine"]="Basic Medical Sciences|Clinical Medicine|Life Stages & Populations|Mental & Behavioral Health|Public Health|Specialties by Setting|Allied Health Services"
  ["History & Heritage"]="Ancient Civilizations|Medieval History|Colonialism & Decolonization|Global Conflicts|Cultural Preservation"
  ["Information & Communication"]="Communication Systems|Media & Journalism|Alt/Resilient Communication|Cybersecurity & Privacy|Information Theory"
  ["Law & Politics"]="Political Systems|Constitutional Law|Governance & Policy|Human Rights|Social Movements"
  ["Mathematics & Logic"]="Foundations|Core Branches|Applied Mathematics|Advanced Fields"
  ["Philosophy & Thought"]="History of Philosophy|Eastern Philosophies|Epistemology|Ethics|Metaphysics"
  ["Practical Skills, Trades & Traditional Craftsmanship"]="Woodworking|Building Techniques|Crafts & Textiles|Land Stewardship|Emergency Skills|Homemade Essentials"
  ["Religion & Spirituality"]="Comparative Religions|Sacred Texts & Theology|Mysticism & Esotericism|Ritual Practices|Symbolism & Archetypes"
  ["Science & Technology"]="Scientific Method|Natural Sciences|Engineering & Design|Computing & AI|Energy Systems"
  ["Society & Humanities"]="Sociology|Anthropology|Cultural Studies|Identity & Intersectionality|Social Research"
  ["Sports & Recreation"]="Sport History|Athletic Methodology|Martial Arts|Outdoor Skills|Games & Play"
  ["Varia"]="Pseudoscience|Urban Legends|Speculative Systems|Creative Experiments"
)

# === Define Topic Maps ===
#Arts & Culture
declare -A ARTS_TOPICS
ARTS_TOPICS=(
  ["Built & Decorative Arts"]="Architecture|Interior Design|Landscaping & Garden Design|Urbanism|Glasswork|Metalworking|Ceramics & Pottery|Woodworking|Jewelry Design"
  ["Visual Arts"]="Drawing|Painting|Printmaking|Sculpture|Textile Arts|3D Art|Digital Arts|Mixed Media|Illustration|Calligraphy"
  ["Performing Arts"]="Dance|Theatre|Opera|Music|Cinema|Performance Art|Improv"
  ["Literary Arts"]="Literature|Poetry|Storytelling"
  ["Meta-Arts (Theory, Systems, Institutions)"]="Art History|Symbolism in Arts|Conceptualizing an Art Project|Artistic Practices & Methodologies|Artistic Movements & Styles|The Art Scene & Communities|Art Curation & Exhibition|Funding & Granting Arts"
)
#Economics & Business
declare -A ECON_TOPICS
ECON_TOPICS=(
  ["Economic Theory & Principles"]="Microeconomics|Macroeconomics|Behavioral Economics|Development Economics|Institutional Economics"
  ["Global & Political Economy"]="Global Trade and Markets|International Economic Systems|Economic History|Economic Policy & Regulation|Economic Inequality & Redistribution"
  ["Business & Enterprise"]="Entrepreneurship & Startups|Business Models & Strategy|Marketing & Branding|Operations & Supply Chain|Financial Planning & Investment"
  ["Corporate & Institutional Systems"]="Corporate Governance|Accounting & Auditing|Banking & Monetary Systems|Venture Capital & Funding|Business Law & Compliance"
  ["Emerging Fields & Intersections"]="Social Entrepreneurship|Green & Sustainable Economics|Crypto & Decentralized Finance (DeFi)|Economic Sociology|Behavioral Finance"
)
#Geography & Environment
declare -A GEO_TOPICS
GEO_TOPICS=(
  ["Earth Systems & Physical Geography"]="Earth Systems & Interactions|Plate Tectonics & Geomorphology|Geological Structures & Topography|Hydrography & Water Systems|Climate Zones & Biomes|Vegetation & Forest Systems|Natural Disasters & Hazard Zones"
  ["Ecology & Life Systems"]="Fauna & Ecological Niches|Ecosystems & Bioregions|Environmental Processes|Biodiversity & Conservation|Ecology & Ecosystem Dynamics"
  ["Human Geography & Spatial Dynamics"]="Human Geography & Migration Patterns|Urbanization & Rural Systems|Political Geography|Cultural Geography|Human-Environment Interactions"
  ["Geographic Theory & Methods"]="Spatial Concepts|Cartography & Mapmaking|GIS & Remote Sensing|Field Observation & Survey Methods"
  ["Environmental Science & Sustainability"]="Environmental Sustainability|Climate Change & Adaptation|Resource Management|Environmental Justice|Resilience & Risk Mitigation"
)
#Health & Medicine
declare -A HEALTH_TOPICS
HEALTH_TOPICS=(
  ["Basic Medical Sciences"]="Anatomy|Physiology|Biochemistry|Pathology|Pharmacology|Microbiology|Genetics"
  ["Clinical Medicine (by system)"]="Cardiology (Heart)|Pulmonology (Lungs)|Neurology (Brain & Nerves)|Gastroenterology (Digestive System)|Nephrology (Kidneys)|Endocrinology (Hormones & Glands)|Hematology (Blood & Bone Marrow)|Dermatology (Skin)|Rheumatology (Joints & Autoimmune)|Infectious Diseases|Allergy & Immunology"
  ["Life Stages & Populations"]="Pediatrics|Geriatrics|Obstetrics & Gynecology|Adolescent Medicine|Neonatology"
  ["Behavioral & Mental Health"]="Psychiatry|Psychology|Substance Use & Addiction|Behavioral Therapy"
  ["Specialties by Care Setting / Modality"]="Emergency Medicine|Critical Care / Intensive Care|Surgery|Radiology (Imaging)|Anesthesiology|Palliative Care|Pain Management|Rehabilitation Medicine"
  ["Public, Social, and Preventive Health"]="Public Health & Epidemiology|Preventive Medicine|Occupational & Environmental Medicine|Global Health|Health Equity & Social Determinants"
  ["Allied Health & Therapies"]="Physical Therapy|Occupational Therapy|Speech-Language Pathology|Medical Laboratory Science|Diagnostic Imaging|Respiratory Therapy|Clinical Pharmacy|Paramedicine"
  ["Digital Health & Informatics"]="Telemedicine|Electronic Health Records (EHRs)|Medical Informatics|Health Apps |Medical devices"
  ["Research, Methods & Innovation"]="Clinical Trial Design|Evidence-Based Medicine|Biostatistics|Translational Medicine|Research Ethics"
  ["Health Systems, Policy & Institutions"]="Medical Ethics|Health Policy & Law|Healthcare Systems & Delivery|Medical Education|Hospital Systems & Administration|Funding Health Care|Drug Approval & Regulation"
)
#History & Heritage
declare -A HISTORY_TOPICS
HISTORY_TOPICS=(
  ["Ancient History & Civilizations"]="Prehistoric Cultures & Human Origins|Mesopotamia & Fertile Crescent|Ancient Egypt|Classical Greece|Roman Empire|Ancient India|Ancient China|Pre-Columbian Americas"
  ["Indigenous Civilizations Worldwide"]="Indigenous Civilizations Worldwide"
  ["Medieval & Pre-Modern Periods"]="Early Middle Ages|High & Late Middle Ages|Islamic Golden Age|Feudal Japan & Samurai Culture|African Kingdoms & Empires|Renaissance & Reformation|Age of Exploration & Contact"
  ["Colonialism, Empire & Decolonization"]="Age of Empire & Imperialism|Atlantic Slave Trade|Colonialism in the Americas|Colonialism in Africa & Asia|Indigenous Resistance & Survival|Movements for Independence|Post-Colonial Realignments"
  ["Modern Conflicts & Global Shifts"]="World War I|World War II|Cold War|Decolonial Conflicts (e.g., Algeria, Vietnam)|Genocides & Human Rights Crises|Rise and Fall of the Soviet Bloc|Contemporary Global Conflict"
  ["Cultural Memory & Preservation"]="Oral Histories & Testimonies|Archival Practices|Historical Sites & Monuments|Cultural Heritage & Identity|Restitution & Repatriation|Historical Narratives & Bias|Museums & Public History"
)
#Information & Communication
declare -A INFO_TOPICS
INFO_TOPICS=(
  ["Communication Systems & Infrastructure"]="Evolution of Communication Technologies (Oral → Print → Digital)|Telecommunication Systems (Telegraph, Telephone, Satellite)|Internet Infrastructure & Protocols (TCP/IP, DNS, HTTP, HTTPS)|Wireless Networks (WiFi, Cellular, LoRa, Satellite)|Data Transmission & Encoding|Cloud Computing & CDN Systems|Routing, Switching, and Backbone Infrastructure|Latency, Bandwidth, and Throughput"
  ["Media Systems & Journalism"]="History of Mass Media (Print, Radio, TV, Digital)|Media Institutions & Ownership|Journalism Ethics & Standards|Freedom of Press & Censorship|Propaganda & Disinformation|Citizen Journalism & Open Publishing|Social Media Platforms & Virality|Media Literacy & Critical Consumption|Infotainment & the Collapse of Boundaries"
  ["Alternative & Resilient Communication"]="Ham Radio & Shortwave|Mesh Networks & P2P Protocols|Emergency Communication Systems|Analog vs. Digital Resilience|Community Networks & Local Broadcasting|Offline-First Communication Tools (e.g., Briar, Scuttlebutt)|Low-Tech Communication in Crisis"
  ["Information Security & Privacy"]="Cybersecurity Fundamentals|Threat Models & Attack Vectors|Firewalls, VPNs & Endpoint Security|Cryptography (Public Key, Symmetric, Hashing)|Digital Hygiene & Personal Privacy|Data Sovereignty & Ownership|Surveillance Capitalism & Data Exploitation|Zero-Trust Architectures|Ethical Hacking & Red Teams"
  ["Meta-Topics (Conceptual / Interdisciplinary)"]="Information Theory (Shannon, entropy, noise)|Network Topologies & Structures|Communication Ethics|Digital Divide & Access Equity|Information Ecosystems & Power|Communication Studies (Semiotics, Discourse, Media Theory)|Techno-Sociology & Platform Studies|History of Written Language & Recording Systems|Post-Literate & AI-Mediated Communication"
)
#Law & Politics
declare -A LAW_TOPICS
LAW_TOPICS=(
  ["Political Systems & Theory"]="Political Systems & Theories (Democracy, Monarchy, Oligarchy, etc.)|Political Ideologies (Liberalism, Socialism, Fascism, Anarchism, etc.)|Political Philosophy (Justice, Authority, Liberty)|Comparative Politics|Political Psychology & Behavior|Political Communication & Propaganda"
  ["Governance & Public Policy"]="Public Policy & Decision-Making|Administrative Systems & Bureaucracy|Government Structures & Electoral Systems|Public Sector Finance & Budgeting|Local vs. Federal Governance|Policy Analysis & Think Tanks"
  ["Legal Systems & Frameworks"]="Constitutional Law|Civil Law vs. Common Law Systems|Criminal Law & Justice|Contract Law|Property Law|Tort Law|Legal Procedure & Due Process|Customary & Indigenous Legal Traditions"
  ["International Law & Human Rights"]="International Law Fundamentals|Human Rights Theory & Instruments|War Law & Humanitarian Law|Treaties & International Agreements|Refugee & Migration Law|Global Courts & Institutions (ICJ, ICC, UN bodies)"
  ["Social Movements & Legal Activism"]="Civil Disobedience & Resistance Theory|Historical Movements (Civil Rights, Suffrage, Labor)|Digital Activism & Protest Tech|Legal Advocacy & Strategic Litigation|NGO & Grassroots Legal Structures"
  ["Meta-Legal Topics & Intersections"]="Philosophy of Law (Jurisprudence)|Legal Ethics|Technology & Law (AI, Privacy, Surveillance)|Access to Justice|Law & Society Studies"
)
#Mathematics & Logic
declare -A MATH_TOPICS
MATH_TOPICS=(
  ["Foundations"]="Arithmetic & Number Concepts|Logic Systems & Proof Theory|Mathematical Logic & Foundations"
  ["Core Branches"]="Algebra|Geometry|Trigonometry|Calculus & Mathematical Analysis|Discrete Mathematics (Combinatorics, Graph Theory)"
  ["Applied Mathematics"]="Probability & Statistics|Applied Mathematics|Game Theory & Decision Theory"
  ["Advanced Fields"]="Number Theory|Topology|Miscellaneous Advanced Topics"
)
#Philosophy & Thought
declare -A PHIL_TOPICS
PHIL_TOPICS=(
  ["History of Philosophy"]="History of Western Philosophy (Ancient → Postmodern)|Eastern Philosophical Traditions (Indian, Chinese, Japanese, etc.)|Islamic Philosophy|African Philosophy|Indigenous Philosophies|Philosophical Movements & Schools (e.g., Existentialism, Stoicism, Structuralism)"
  ["Core Branches of Philosophy"]="Metaphysics (What exists?)|Epistemology (How do we know?)|Ethics & Moral Philosophy (What is right?)|Logic (What is valid reasoning?)|Aesthetics (What is beauty?)|Political Philosophy (What is justice?)"
  ["Methods, Systems & Frameworks"]="Critical Thinking & Argumentation|Philosophy of Language|Philosophy of Mind|Phenomenology & Hermeneutics|Dialectics & Socratic Method|Conceptual Analysis"
  ["Interdisciplinary Philosophy"]="Philosophy of Science|Philosophy of Law|Philosophy of Technology|Environmental Philosophy|Philosophy of Religion|Cognitive & Experimental Philosophy"
  ["Meta-Philosophy"]="What is Philosophy?|Philosophy as Praxis|Academic vs. Popular Philosophy|Philosophy & Culture|The Role of the Philosopher"
)
#Practical Skills, Trades & Traditional Craftsmanship
declare -A PRACTICAL_TOPICS
PRACTICAL_TOPICS=(
  ["Wood, Metal & Construction"]="Woodworking & Joinery|Carpentry & Framing|Timber Framing & Log Building|Blacksmithing & Metalworking|Toolmaking & Tool Maintenance|Knife Making & Sharpening|Welding & Fabrication|Traditional Masonry & Stonework|Sustainable Building Techniques (e.g., Cob, Straw Bale, Earthship)|Tiny Homes & Off-Grid Structures"
  ["Textile, Fiber & Material Arts"]="Spinning & Weaving|Natural Dyeing|Sewing & Mending|Quilting|Leatherworking|Basketry|Rope & Cordage Making|Feltmaking|Embroidery & Decorative Arts"
  ["Agriculture, Foraging & Land Stewardship"]="Permaculture|Soil Regeneration|Composting & Natural Fertilizers|Mycology & Mushroom Identification|Wild Plant Foraging & Edible Flora|Seed Saving|Companion Planting|Agroforestry|Small-Scale Animal Husbandry|Beekeeping"
  ["Survival, Bushcraft & Emergency Readiness"]="Emergency Preparedness (Go Bags, Plans, Communications)|Fire Building & Primitive Tools|Water Purification & Storage|First Aid & Herbal Remedies|Shelter Building|Navigation & Orienteering|Trapping, Fishing & Hunting Basics|Cold Climate & Seasonal Adaptation|Sustainable Tool Use in Crisis"
  ["Food Preparation & Preservation"]="Cooking Techniques (boiling, baking, fermentation, roasting, etc.)|Traditional & Regional Recipes|Outdoor & Primitive Cooking|Food Preservation (canning, pickling, drying, salting)|Fermentation & Probiotics|Root Cellaring & Cold Storage|Breadmaking & Grains|Dairy Processing (cheese, yogurt, ghee)|Meat Preservation (jerky, curing, smoking)|Seasonal Food Planning"
  ["Energy, Water & Shelter Systems"]="Water Collection & Filtration|Rainwater Harvesting Systems|Solar Power Systems|Battery Storage & Inverters|Wood Stoves & Heating Efficiency|Insulation & Passive Thermal Design|Basic Plumbing & Greywater Recycling|Composting Toilets & Sanitation"
  ["Domestic Infrastructure & Maintenance"]="Basic Plumbing & Repairs|Electrical Safety & DIY Fixes|Household Waste Systems|Natural Cleaning Products|Home Maintenance Calendars"
  ["Homemade Essentials"]="Body Care Products (Toothpaste, Deodorant)|Natural Healing (Herbal Medicine Basics
|Plant-Based Antiseptics)|Household Cleaning (All-Purpose Cleaners, Natural Scrubs)|Paper & Fibers (Homemade Paper, Beeswax Wraps)|Fuel, Fire, and Light (DIY Candles, Oil Lamps)|Textiles & Storage (Handmade Rope, Quilted Storage Pouches)"
  ["Cultural & Traditional Knowledge"]="Folk Crafts & Regional Techniques|Oral Knowledge Transfer & Memory Skills|Craft Philosophy & Work Ethic|Guilds, Apprenticeship & Lineage|Rituals of Making (e.g., seasonal dyeing, ceremonial tool use)"
)
#Religion & Spirituality
declare -A RELIGION_TOPICS
RELIGION_TOPICS=(
  ["Comparative Religions & Traditions"]="World Religions Overview|Abrahamic Traditions (Judaism, Christianity, Islam)|Dharmic Traditions (Hinduism, Buddhism, Jainism, Sikhism)|East Asian Traditions (Taoism, Confucianism, Shinto)|Indigenous & Earth-Based Spiritualities|African Traditional Religions|Animism & Shamanic Practices|Interfaith Dialogue & Comparative Frameworks"
  ["Sacred Texts, Doctrine & Theology"]="Canonical Texts (e.g. Torah, Bible, Quran, Vedas, Tripitaka)|Theology & Doctrinal Systems|Exegesis & Hermeneutics|Revelation, Prophecy & Myth|Afterlife, Salvation & Cosmology|Moral & Ethical Systems"
  ["Rituals, Practices & Embodied Belief"]="Sacred Time (Festivals, Holy Days, Cycles)|Sacred Space (Temples, Altars, Pilgrimage)|Prayer, Chanting, Meditation, Mantra|Fasting, Feasting & Asceticism|Anointing, Blessing, Cleansing|Rites of Passage (Birth, Initiation, Death)"
  ["Mysticism, Esotericism & Inner Paths"]="Mystical Traditions (Sufism, Kabbalah, Gnostic Christianity)|Alchemy, Astrology & Sacred Geometry|Divination Systems (Tarot, Runes, I Ching)|Secret Societies & Initiatory Orders|Esoteric Cosmologies|Spiritual Transformation & Awakening"
  ["Mythology, Archetypes & Symbolism"]="Archetypes in Religion & Psychology|Comparative Mythology|Hero’s Journey & Sacred Narrative|Creation Myths|Symbols, Sigils, Totems|Syncretism & Symbolic Crossovers"
  ["Institutions, Power & Fringe Movements"]="Church-State Relationships|Religious Institutions & Clergy|New Religious Movements (NRMs)|Cults, Sects & Charismatic Leadership|Religious Trauma & Deconstruction|Religion & Social Control|Religion in the Modern World"
)
#Science & Technology
declare -A SCIENCE_TOPICS
SCIENCE_TOPICS=(
  ["Foundational Sciences"]="Scientific Methodology|Classical Physics (Mechanics, Thermodynamics, Electromagnetism)|Chemistry (General, Organic, Inorganic)|Biology (Cell Biology, Genetics, Evolution)|Earth & Planetary Sciences (Geology, Meteorology, Oceanography)|Astronomy & Astrophysics"
  ["Cognitive & Mathematical Sciences"]="Cognitive Science|Neuroscience|Mathematical Modeling & Simulation|Systems Theory & Cybernetics"
  ["Engineering & Applied Sciences"]="Mechanical Engineering|Electrical & Electronic Engineering|Civil & Structural Engineering|Chemical Engineering|Materials Science|Nanotechnology|Environmental Engineering"
  ["Life Sciences & Health Technologies"]="Biotechnology|Biomedical Engineering|Genetics & Genomics|Synthetic Biology|Pharmacology & Drug Development"
  ["Computer & Information Sciences"]="Computer Science Fundamentals|Software Engineering|Artificial Intelligence & Machine Learning|Human-Computer Interaction (HCI)|Information Theory|Quantum Computing"
  ["Sustainability, Energy & Environment"]="Renewable Energy Systems|Sustainable Technology Design|Energy Storage & Grid Systems|Climate Science Technologies"
  ["Emerging & Interdisciplinary Fields"]="Robotics & Automation|Space Sciences & Technologies|Bioinformatics|Internet of Things (IoT)|Ethics of Emerging Technologies"
)
#Society & Humanities
declare -A SOC_TOPICS
SOC_TOPICS=(
  ["Sociology"]="Social Structures|Social Institutions|Social Change|Research Methods"
  ["Anthropology"]="Cultural Anthropology|Archaeology|Linguistic Anthropology"
  ["Cultural Studies"]="Cultural Theory|Media Studies|Identity Politics"
  ["Identity, Power & Representation"]="Gender Studies & Identity|Queer Theory|Race & Ethnicity|Intersectionality|Disability Studies|Postcolonial & Decolonial Theory|Body, Embodiment & Representation"
  ["Culture, Theory & Semiotics"]="Cultural Theory|Structuralism & Post-Structuralism|Symbolic Interactionism|Semiotics & Meaning-Making|Popular Culture & Media Theory|Subcultures & Countercultures"
  ["Globalization, Exchange & Flows"]="Globalization & Cultural Exchange|Diaspora & Transnationalism|Migration & Refugee Studies|Global Media Flows|Cultural Hybridity & Fusion|Cultural Imperialism & Resistance"
  ["Social Research & Methods"]="Qualitative Methods (Interviews, Observations, Ethnography)|Quantitative Methods (Surveys, Stats, Demographics)|Discourse Analysis|Critical Theory & Reflexivity|Ethics in Social Research|Participatory & Action Research"
)
#Sports & Recreation
declare -A SPORTS_TOPICS
SPORTS_TOPICS=(
  ["History, Institutions & Cultural Impact"]="History of the Olympic Games|Origins of Traditional Sports & Games|Sport in Ancient Civilizations|Professional Leagues & Organizations|Sport and National Identity|Politics, Economics, and the Globalization of Sport"
  ["Theory, Mind & Method"]="Training Methodologies in Athletics|Sports Psychology|Flow States & Performance|Motivation, Habit & Goal-Setting|Injury Prevention & Recovery|Biofeedback, Tracking, and Tech in Training"
  ["Martial Arts & Combat Traditions"]="Martial Arts Systems (e.g., Karate, Judo, Kung Fu, BJJ, etc.)|Weapon-Based Traditions (e.g., Fencing, Kendo, Escrima)|Philosophical Roots & Spiritual Disciplines|Self-Defense & Practical Application|Cultural Symbolism & Martial Lineages"
  ["Movement & Physical Culture"]="Running, Endurance & Cardio Disciplines|Strength Training & Calisthenics|Flexibility & Mobility Practices|Functional Fitness & Movement Therapy|Parkour & Natural Movement|Dance & Expressive Body Practice"
  ["Outdoor Skills, Recreation & Adventure"]="Outdoor Survival Skills|Hiking, Backpacking & Orienteering|Rock Climbing & Bouldering|Camping Systems & Gear|Paddling, Rowing & Water Navigation|Winter Sports & Cold Resilience|Adventure Planning & Risk Assessment"
  ["Games, Play & Social Recreation"]="Board Games & Roleplaying Systems|Strategy & Simulation Sports|Movement-Based Social Games|Community Recreation Models|Digital Sports & eSports|Leisure Theory & the Philosophy of Play"
)
#Varia
declare -A VARIA_TOPICS
VARIA_TOPICS=(
  ["Pseudoscience"]="Astrology|Homeopathy|Crystal Healing|Alternative Medicine|Conspiracy Theories"
  ["Urban Legends"]="Creepy Pasta|Internet Urban Legends|Folklore & Mythology|Modern Folklore"
  ["Speculative Systems"]="Worldbuilding|Alternate History|Fictional Economies|Speculative Fiction"
  ["Creative Experiments"]="Artistic Experiments|DIY Projects|Creative Writing Prompts|Experimental Music"
)

# === Generate Folders ===
for domain in "${!TOPICS[@]}"; do
  domain_path="$NOTES_ROOT/$domain"
  create_markdown_pair "$domain_path" "$domain" "domain" "Personal Encyclopedia"

  IFS='|' read -ra topics <<< "${TOPICS[$domain]}"
  for topic in "${topics[@]}"; do
    topic_path="$domain_path/$topic"
    create_markdown_pair "$topic_path" "$topic" "topic" "$domain"

    IFS='|' read -ra subtopics <<< "${TOPICS[$topic]}"
    for subtopic in "${subtopics[@]}"; do
      sub_path="$topic_path/$subtopic"
      create_markdown_pair "$sub_path" "$subtopic" "note" "$topic"
    done
  done  
  for topic in "${topics[@]}"; do
    topic_path="$domain_path/$topic"
    create_markdown_pair "$topic_path" "$topic" "topic" "$domain"

  if [[ "$domain" == "Arts & Culture" ]]; then
    create_structure_from_map "$domain_path" "$domain" ARTS_TOPICS
  elif [[ "$domain" == "Economics & Business" ]]; then
    create_structure_from_map "$domain_path" "$domain" ECON_TOPICS
  elif [[ "$domain" == "Geography & Environment" ]]; then
    create_structure_from_map "$domain_path" "$domain" GEO_TOPICS
  elif [[ "$domain" == "Health & Medicine" ]]; then
    create_structure_from_map "$domain_path" "$domain" HEALTH_TOPICS
  elif [[ "$domain" == "History & Heritage" ]]; then
    create_structure_from_map "$domain_path" "$domain" HISTORY_TOPICS
  elif [[ "$domain" == "Information & Communication" ]]; then
    create_structure_from_map "$domain_path" "$domain" INFO_TOPICS
  elif [[ "$domain" == "Law & Politics" ]]; then
    create_structure_from_map "$domain_path" "$domain" LAW_TOPICS
  elif [[ "$domain" == "Mathematics & Logic" ]]; then
    create_structure_from_map "$domain_path" "$domain" MATH_TOPICS
  elif [[ "$domain" == "Philosophy & Thought" ]]; then
    create_structure_from_map "$domain_path" "$domain" PHIL_TOPICS
  elif [[ "$domain" == "Practical Skills, Trades & Traditional Craftsmanship" ]]; then
    create_structure_from_map "$domain_path" "$domain" PRACTICAL_TOPICS
  elif [[ "$domain" == "Religion & Spirituality" ]]; then
    create_structure_from_map "$domain_path" "$domain" RELIGION_TOPICS
  elif [[ "$domain" == "Science & Technology" ]]; then
    create_structure_from_map "$domain_path" "$domain" SCIENCE_TOPICS
  elif [[ "$domain" == "Society & Humanities" ]]; then
    create_structure_from_map "$domain_path" "$domain" SOC_TOPICS
  elif [[ "$domain" == "Sports & Recreation" ]]; then
    create_structure_from_map "$domain_path" "$domain" SPORTS_TOPICS
  elif [[ "$domain" == "Varia" ]]; then
    create_structure_from_map "$domain_path" "$domain" VARIA_TOPICS
  fi
done

# === Completion ===
if $DRY_RUN; then
  echo "✅ DRY-RUN complete. No files or folders created."
else
  echo "✅ Personal Encyclopedia structure created successfully at: $NOTES_ROOT"
fi
  echo "🔍 Check the structure and adjust as needed."

# End of script
# -----------------------------------------------------------------------------------
# This script is designed to create a structured directory for managing topics and notes
# in an Obsidian vault. It includes domains and topics, each with a dedicated folder and
# a sample note. The script is modular and can be easily extended to include more domains
# and topics as needed. The DRY-RUN mode allows for a preview of the changes without
# making any modifications to the file system.
# The script includes safety checks to ensure the vault path exists before proceeding
# with folder creation. It is designed to be user-friendly and provides clear feedback
# on the actions taken.
# -----------------------------------------------------------------------------------
# This script is intended for educational purposes and should be used with caution.
# The author is not responsible for any data loss or corruption that may occur
# Always back up your data before running scripts that modify file systems.
# Use at your own risk.
# -----------------------------------------------------------------------------------