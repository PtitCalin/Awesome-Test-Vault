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
  done
}

# === Full Encyclopedia Structure ===
# == Define the main topics maps ==
declare -A TOPICS
TOPICS=(
  ["Arts and Culture"]="Built and Decorative Arts|Visual Arts|Performing Arts|Literary Arts|Meta-Arts Theory Systems Institutions"
  ["Economics and Business"]="Microeconomics|Macroeconomics|Behavioral Economics|Entrepreneurship and Startups|Business Strategy"
  ["Geography and Environment"]="Earth Systems|Human Geography|Climate and Biomes|Environmental Sustainability|Disaster Resilience"
  ["Health and Medicine"]="Basic Medical Sciences|Clinical Medicine|Life Stages and Populations|Mental and Behavioral Health|Public Health|Specialties by Setting|Allied Health Services"
  ["History and Heritage"]="Ancient Civilizations|Medieval History|Colonialism and Decolonization|Global Conflicts|Cultural Preservation"
  ["Information and Communication"]="Communication Systems|Media and Journalism|Alt-Resilient Communication|Cybersecurity and Privacy|Information Theory"
  ["Law and Politics"]="Political Systems|Constitutional Law|Governance and Policy|Human Rights|Social Movements"
  ["Mathematics and Logic"]="Foundations|Core Branches|Applied Mathematics|Advanced Fields"
  ["Philosophy and Thought"]="History of Philosophy|Eastern Philosophies|Epistemology|Ethics|Metaphysics"
  ["Practical Skills Trades and Traditional Craftsmanship"]="Woodworking|Building Techniques|Crafts and Textiles|Land Stewardship|Emergency Skills|Homemade Essentials"
  ["Religion and Spirituality"]="Comparative Religions|Sacred Texts and Theology|Mysticism and Esotericism|Ritual Practices|Symbolism and Archetypes"
  ["Science and Technology"]="Scientific Method|Natural Sciences|Engineering and Design|Computing and AI|Energy Systems"
  ["Society and Humanities"]="Sociology|Anthropology|Cultural Studies|Identity and Intersectionality|Social Research"
  ["Sports and Recreation"]="Sport History|Athletic Methodology|Martial Arts|Outdoor Skills|Games and Play"
  ["Varia"]="Pseudoscience|Urban Legends|Speculative Systems|Creative Experiments"
)

# == Define Topic Maps ==
#Arts & Culture
declare -A ARTS_TOPICS
ARTS_TOPICS=(
  ["Built and Decorative Arts"]="Architecture|Interior Design|Landscaping and Garden Design|Urbanism|Glasswork|Metalworking|Ceramics and Pottery|Woodworking|Jewelry Design"
  ["Visual Arts"]="Drawing|Painting|Printmaking|Sculpture|Textile Arts|3D Art|Digital Arts|Mixed Media|Illustration|Calligraphy"
  ["Performing Arts"]="Dance|Theatre|Opera|Music|Cinema|Performance Art|Improv"
  ["Literary Arts"]="Literature|Poetry|Storytelling"
  ["Meta-Arts Theory Systems Institutions"]="Art History|Symbolism in Arts|Conceptualizing an Art Project|Artistic Practices and Methodologies|Artistic Movements and Styles|The Art Scene and Communities|Art Curation and Exhibition|Funding and Granting Arts"
)
#Economics & Business
declare -A ECON_TOPICS
ECON_TOPICS=(
  ["Economic Theory and Principles"]="Microeconomics|Macroeconomics|Behavioral Economics|Development Economics|Institutional Economics"
  ["Global and Political Economy"]="Global Trade and Markets|International Economic Systems|Economic History|Economic Policy and Regulation|Economic Inequality and Redistribution"
  ["Business and Enterprise"]="Entrepreneurship and Startups|Business Models and Strategy|Marketing and Branding|Operations and Supply Chain|Financial Planning and Investment"
  ["Corporate and Institutional Systems"]="Corporate Governance|Accounting and Auditing|Banking and Monetary Systems|Venture Capital and Funding|Business Law and Compliance"
  ["Emerging Fields and Intersections"]="Social Entrepreneurship|Green and Sustainable Economics|Crypto and Decentralized Finance DeFi|Economic Sociology|Behavioral Finance"
)
#Geography & Environment
declare -A GEO_TOPICS
GEO_TOPICS=(
  ["Earth Systems and Physical Geography"]="Earth Systems and Interactions|Plate Tectonics and Geomorphology|Geological Structures and Topography|Hydrography and Water Systems|Climate Zones and Biomes|Vegetation and Forest Systems|Natural Disasters and Hazard Zones"
  ["Ecology and Life Systems"]="Fauna and Ecological Niches|Ecosystems and Bioregions|Environmental Processes|Biodiversity and Conservation|Ecology and Ecosystem Dynamics"
  ["Human Geography and Spatial Dynamics"]="Human Geography and Migration Patterns|Urbanization and Rural Systems|Political Geography|Cultural Geography|Human-Environment Interactions"
  ["Geographic Theory and Methods"]="Spatial Concepts|Cartography and Mapmaking|GIS and Remote Sensing|Field Observation and Survey Methods"
  ["Environmental Science and Sustainability"]="Environmental Sustainability|Climate Change and Adaptation|Resource Management|Environmental Justice|Resilience and Risk Mitigation"
)
#Health & Medicine
declare -A HEALTH_TOPICS
HEALTH_TOPICS=(
  ["Basic Medical Sciences"]="Anatomy|Physiology|Biochemistry|Pathology|Pharmacology|Microbiology|Genetics"
  ["Clinical Medicine by system"]="Cardiology - Heart|Pulmonology - Lungs|Neurology - Brain and Nerves|Gastroenterology - Digestive System|Nephrology - Kidneys|Endocrinology - Hormones and Glands|Hematology - Blood and Bone Marrow|Dermatology - Skin|Rheumatology - Joints and Autoimmune|Infectious Diseases|Allergy and Immunology"
  ["Life Stages and Populations"]="Pediatrics|Geriatrics|Obstetrics and Gynecology|Adolescent Medicine|Neonatology"
  ["Behavioral and Mental Health"]="Psychiatry|Psychology|Substance Use and Addiction|Behavioral Therapy"
  ["Specialties by Care Setting - Modality"]="Emergency Medicine|Critical Care - Intensive Care|Surgery|Radiology - Imaging|Anesthesiology|Palliative Care|Pain Management|Rehabilitation Medicine"
  ["Public Social and Preventive Health"]="Public Health and Epidemiology|Preventive Medicine|Occupational and Environmental Medicine|Global Health|Health Equity and Social Determinants"
  ["Allied Health and Therapies"]="Physical Therapy|Occupational Therapy|Speech-Language Pathology|Medical Laboratory Science|Diagnostic Imaging|Respiratory Therapy|Clinical Pharmacy|Paramedicine"
  ["Digital Health and Informatics"]="Telemedicine|Electronic Health Records - EHRs|Medical Informatics|Health Apps|Medical devices"
  ["Research Methods and Innovation"]="Clinical Trial Design|Evidence-Based Medicine|Biostatistics|Translational Medicine|Research Ethics"
  ["Health Systems Policy and Institutions"]="Medical Ethics|Health Policy and Law|Healthcare Systems and Delivery|Medical Education|Hospital Systems and Administration|Funding Health Care|Drug Approval and Regulation"
)
#History & Heritage
declare -A HISTORY_TOPICS
HISTORY_TOPICS=(
  ["Ancient History and Civilizations"]="Prehistoric Cultures and Human Origins|Mesopotamia and Fertile Crescent|Ancient Egypt|Classical Greece|Roman Empire|Ancient India|Ancient China|Pre-Columbian Americas"
  ["Indigenous Civilizations Worldwide"]="Indigenous Civilizations Worldwide"
  ["Medieval and Pre-Modern Periods"]="Early Middle Ages|High and Late Middle Ages|Islamic Golden Age|Feudal Japan and Samurai Culture|African Kingdoms and Empires|Renaissance and Reformation|Age of Exploration and Contact"
  ["Colonialism Empire and Decolonization"]="Age of Empire and Imperialism|Atlantic Slave Trade|Colonialism in the Americas|Colonialism in Africa and Asia|Indigenous Resistance and Survival|Movements for Independence|Post-Colonial Realignments"
  ["Modern Conflicts and Global Shifts"]="World War I|World War II|Cold War|Decolonial Conflicts - Algeria, Vietnam|Genocides and Human Rights Crises|Rise and Fall of the Soviet Bloc|Contemporary Global Conflict"
  ["Cultural Memory and Preservation"]="Oral Histories and Testimonies|Archival Practices|Historical Sites and Monuments|Cultural Heritage and Identity|Restitution and Repatriation|Historical Narratives and Bias|Museums and Public History"
)
#Information & Communication
declare -A INFO_TOPICS
INFO_TOPICS=(
  ["Communication Systems and Infrastructure"]="Evolution of Communication Technologies - Oral to Print to Digital|Telecommunication Systems - Telegraph, Telephone, Satellite|Internet Infrastructure and Protocols - TCP-IP, DNS, HTTP, HTTPS|Wireless Networks - WiFi, Cellular, LoRa, Satellite|Data Transmission and Encoding|Cloud Computing and CDN Systems|Routing, Switching, and Backbone Infrastructure|Latency, Bandwidth, and Throughput"
  ["Media Systems and Journalism"]="History of Mass Media - Print, Radio, TV, Digital|Media Institutions and Ownership|Journalism Ethics and Standards|Freedom of Press and Censorship|Propaganda and Disinformation|Citizen Journalism and Open Publishing|Social Media Platforms and Virality|Media Literacy and Critical Consumption|Infotainment and the Collapse of Boundaries"
  ["Alternative and Resilient Communication"]="Ham Radio and Shortwave|Mesh Networks and P2P Protocols|Emergency Communication Systems|Analog vs. Digital Resilience|Community Networks and Local Broadcasting|Offline-First Communication Tools - Briar, Scuttlebutt|Low-Tech Communication in Crisis"
  ["Information Security and Privacy"]="Cybersecurity Fundamentals|Threat Models and Attack Vectors|Firewalls, VPNs and Endpoint Security|Cryptography - Public Key, Symmetric, Hashing|Digital Hygiene and Personal Privacy|Data Sovereignty and Ownership|Surveillance Capitalism and Data Exploitation|Zero-Trust Architectures|Ethical Hacking and Red Teams"
  ["Meta-Topics - Conceptual and Interdisciplinary"]="Information Theory - Shannon, entropy, noise|Network Topologies and Structures|Communication Ethics|Digital Divide and Access Equity|Information Ecosystems and Power|Communication Studies - Semiotics, Discourse, Media Theory|Techno-Sociology and Platform Studies|History of Written Language and Recording Systems|Post-Literate and AI-Mediated Communication"
)
#Law & Politics
declare -A LAW_TOPICS
LAW_TOPICS=(
  ["Political Systems and Theory"]="Political Systems and Theories - Democracy, Monarchy, Oligarchy|Political Ideologies - Liberalism, Socialism, Fascism, Anarchism|Political Philosophy - Justice, Authority, Liberty|Comparative Politics|Political Psychology and Behavior|Political Communication and Propaganda"
  ["Governance and Public Policy"]="Public Policy and Decision-Making|Administrative Systems and Bureaucracy|Government Structures and Electoral Systems|Public Sector Finance and Budgeting|Local vs. Federal Governance|Policy Analysis and Think Tanks"
  ["Legal Systems and Frameworks"]="Constitutional Law|Civil Law vs. Common Law Systems|Criminal Law and Justice|Contract Law|Property Law|Tort Law|Legal Procedure and Due Process|Customary and Indigenous Legal Traditions"
  ["International Law and Human Rights"]="International Law Fundamentals|Human Rights Theory and Instruments|War Law and Humanitarian Law|Treaties and International Agreements|Refugee and Migration Law|Global Courts and Institutions - ICJ, ICC, UN bodies"
  ["Social Movements and Legal Activism"]="Civil Disobedience and Resistance Theory|Historical Movements - Civil Rights, Suffrage, Labor|Digital Activism and Protest Tech|Legal Advocacy and Strategic Litigation|NGO and Grassroots Legal Structures"
  ["Meta-Legal Topics and Intersections"]="Philosophy of Law - Jurisprudence|Legal Ethics|Technology and Law - AI, Privacy, Surveillance|Access to Justice|Law and Society Studies"
)
#Mathematics & Logic
declare -A MATH_TOPICS
MATH_TOPICS=(
  ["Foundations"]="Arithmetic and Number Concepts|Logic Systems and Proof Theory|Mathematical Logic and Foundations"
  ["Core Branches"]="Algebra|Geometry|Trigonometry|Calculus and Mathematical Analysis|Discrete Mathematics - Combinatorics, Graph Theory"
  ["Applied Mathematics"]="Probability and Statistics|Applied Mathematics|Game Theory and Decision Theory"
  ["Advanced Fields"]="Number Theory|Topology|Miscellaneous Advanced Topics"
)
#Philosophy & Thought
declare -A PHIL_TOPICS
PHIL_TOPICS=(
  ["History of Philosophy"]="History of Western Philosophy - Ancient to Postmodern|Eastern Philosophical Traditions - Indian, Chinese, Japanese|Islamic Philosophy|African Philosophy|Indigenous Philosophies|Philosophical Movements and Schools - Existentialism, Stoicism, Structuralism"
  ["Core Branches of Philosophy"]="Metaphysics - What exists|Epistemology - How do we know|Ethics and Moral Philosophy - What is right|Logic - What is valid reasoning|Aesthetics - What is beauty|Political Philosophy - What is justice"
  ["Methods, Systems and Frameworks"]="Critical Thinking and Argumentation|Philosophy of Language|Philosophy of Mind|Phenomenology and Hermeneutics|Dialectics and Socratic Method|Conceptual Analysis"
  ["Interdisciplinary Philosophy"]="Philosophy of Science|Philosophy of Law|Philosophy of Technology|Environmental Philosophy|Philosophy of Religion|Cognitive and Experimental Philosophy"
  ["Meta-Philosophy"]="What is Philosophy|Philosophy as Praxis|Academic vs. Popular Philosophy|Philosophy and Culture|The Role of the Philosopher"
)
#Practical Skills, Trades & Traditional Craftsmanship
declare -A PRACTICAL_TOPICS
PRACTICAL_TOPICS=(
  ["Wood, Metal and Construction"]="Woodworking and Joinery|Carpentry and Framing|Timber Framing and Log Building|Blacksmithing and Metalworking|Toolmaking and Tool Maintenance|Knife Making and Sharpening|Welding and Fabrication|Traditional Masonry and Stonework|Sustainable Building Techniques - Cob, Straw Bale, Earthship|Tiny Homes and Off-Grid Structures"
  ["Textile, Fiber and Material Arts"]="Spinning and Weaving|Natural Dyeing|Sewing and Mending|Quilting|Leatherworking|Basketry|Rope and Cordage Making|Feltmaking|Embroidery and Decorative Arts"
  ["Agriculture, Foraging and Land Stewardship"]="Permaculture|Soil Regeneration|Composting and Natural Fertilizers|Mycology and Mushroom Identification|Wild Plant Foraging and Edible Flora|Seed Saving|Companion Planting|Agroforestry|Small-Scale Animal Husbandry|Beekeeping"
  ["Survival, Bushcraft and Emergency Readiness"]="Emergency Preparedness - Go Bags, Plans, Communications|Fire Building and Primitive Tools|Water Purification and Storage|First Aid and Herbal Remedies|Shelter Building|Navigation and Orienteering|Trapping, Fishing and Hunting Basics|Cold Climate and Seasonal Adaptation|Sustainable Tool Use in Crisis"
  ["Food Preparation and Preservation"]="Cooking Techniques - boiling, baking, fermentation, roasting|Traditional and Regional Recipes|Outdoor and Primitive Cooking|Food Preservation - canning, pickling, drying, salting|Fermentation and Probiotics|Root Cellaring and Cold Storage|Breadmaking and Grains|Dairy Processing - cheese, yogurt, ghee|Meat Preservation - jerky, curing, smoking|Seasonal Food Planning"
  ["Energy, Water and Shelter Systems"]="Water Collection and Filtration|Rainwater Harvesting Systems|Solar Power Systems|Battery Storage and Inverters|Wood Stoves and Heating Efficiency|Insulation and Passive Thermal Design|Basic Plumbing and Greywater Recycling|Composting Toilets and Sanitation"
  ["Domestic Infrastructure and Maintenance"]="Basic Plumbing and Repairs|Electrical Safety and DIY Fixes|Household Waste Systems|Natural Cleaning Products|Home Maintenance Calendars"
  ["Homemade Essentials"]="Body Care Products - Toothpaste, Deodorant|Natural Healing - Herbal Medicine Basics, Plant-Based Antiseptics|Household Cleaning - All-Purpose Cleaners, Natural Scrubs|Paper and Fibers - Homemade Paper, Beeswax Wraps|Fuel, Fire and Light - DIY Candles, Oil Lamps|Textiles and Storage - Handmade Rope, Quilted Storage Pouches"
  ["Cultural and Traditional Knowledge"]="Folk Crafts and Regional Techniques|Oral Knowledge Transfer and Memory Skills|Craft Philosophy and Work Ethic|Guilds, Apprenticeship and Lineage|Rituals of Making - seasonal dyeing, ceremonial tool use"
)
#Religion & Spirituality
declare -A RELIGION_TOPICS
RELIGION_TOPICS=(
  ["Comparative Religions and Traditions"]="World Religions Overview|Abrahamic Traditions - Judaism, Christianity, Islam|Dharmic Traditions - Hinduism, Buddhism, Jainism, Sikhism|East Asian Traditions - Taoism, Confucianism, Shinto|Indigenous and Earth-Based Spiritualities|African Traditional Religions|Animism and Shamanic Practices|Interfaith Dialogue and Comparative Frameworks"
  ["Sacred Texts, Doctrine and Theology"]="Canonical Texts - Torah, Bible, Quran, Vedas, Tripitaka|Theology and Doctrinal Systems|Exegesis and Hermeneutics|Revelation, Prophecy and Myth|Afterlife, Salvation and Cosmology|Moral and Ethical Systems"
  ["Rituals, Practices and Embodied Belief"]="Sacred Time - Festivals, Holy Days, Cycles|Sacred Space - Temples, Altars, Pilgrimage|Prayer, Chanting, Meditation, Mantra|Fasting, Feasting and Asceticism|Anointing, Blessing, Cleansing|Rites of Passage - Birth, Initiation, Death"
  ["Mysticism, Esotericism and Inner Paths"]="Mystical Traditions - Sufism, Kabbalah, Gnostic Christianity|Alchemy, Astrology and Sacred Geometry|Divination Systems - Tarot, Runes, I Ching|Secret Societies and Initiatory Orders|Esoteric Cosmologies|Spiritual Transformation and Awakening"
  ["Mythology, Archetypes and Symbolism"]="Archetypes in Religion and Psychology|Comparative Mythology|Heros Journey and Sacred Narrative|Creation Myths|Symbols, Sigils, Totems|Syncretism and Symbolic Crossovers"
  ["Institutions, Power and Fringe Movements"]="Church-State Relationships|Religious Institutions and Clergy|New Religious Movements - NRMs|Cults, Sects and Charismatic Leadership|Religious Trauma and Deconstruction|Religion and Social Control|Religion in the Modern World"
)
#Science & Technology
declare -A SCIENCE_TOPICS
SCIENCE_TOPICS=(
  ["Foundational Sciences"]="Scientific Methodology|Classical Physics - Mechanics, Thermodynamics, Electromagnetism|Chemistry - General, Organic, Inorganic|Biology - Cell Biology, Genetics, Evolution|Earth and Planetary Sciences - Geology, Meteorology, Oceanography|Astronomy and Astrophysics"
  ["Cognitive and Mathematical Sciences"]="Cognitive Science|Neuroscience|Mathematical Modeling and Simulation|Systems Theory and Cybernetics"
  ["Engineering and Applied Sciences"]="Mechanical Engineering|Electrical and Electronic Engineering|Civil and Structural Engineering|Chemical Engineering|Materials Science|Nanotechnology|Environmental Engineering"
  ["Life Sciences and Health Technologies"]="Biotechnology|Biomedical Engineering|Genetics and Genomics|Synthetic Biology|Pharmacology and Drug Development"
  ["Computer and Information Sciences"]="Computer Science Fundamentals|Software Engineering|Artificial Intelligence and Machine Learning|Human-Computer Interaction - HCI|Information Theory|Quantum Computing"
  ["Sustainability, Energy and Environment"]="Renewable Energy Systems|Sustainable Technology Design|Energy Storage and Grid Systems|Climate Science Technologies"
  ["Emerging and Interdisciplinary Fields"]="Robotics and Automation|Space Sciences and Technologies|Bioinformatics|Internet of Things - IoT|Ethics of Emerging Technologies"
)
#Society & Humanities
declare -A SOC_TOPICS
SOC_TOPICS=(
  ["Sociology"]="Social Structures|Social Institutions|Social Change|Research Methods"
  ["Anthropology"]="Cultural Anthropology|Archaeology|Linguistic Anthropology"
  ["Cultural Studies"]="Cultural Theory|Media Studies|Identity Politics"
  ["Identity, Power and Representation"]="Gender Studies and Identity|Queer Theory|Race and Ethnicity|Intersectionality|Disability Studies|Postcolonial and Decolonial Theory|Body, Embodiment and Representation"
  ["Culture, Theory and Semiotics"]="Cultural Theory|Structuralism and Post-Structuralism|Symbolic Interactionism|Semiotics and Meaning-Making|Popular Culture and Media Theory|Subcultures and Countercultures"
  ["Globalization, Exchange and Flows"]="Globalization and Cultural Exchange|Diaspora and Transnationalism|Migration and Refugee Studies|Global Media Flows|Cultural Hybridity and Fusion|Cultural Imperialism and Resistance"
  ["Social Research and Methods"]="Qualitative Methods - Interviews, Observations, Ethnography|Quantitative Methods - Surveys, Stats, Demographics|Discourse Analysis|Critical Theory and Reflexivity|Ethics in Social Research|Participatory and Action Research"
)
#Sports & Recreation
declare -A SPORTS_TOPICS
SPORTS_TOPICS=(
  ["History, Institutions and Cultural Impact"]="History of the Olympic Games|Origins of Traditional Sports and Games|Sport in Ancient Civilizations|Professional Leagues and Organizations|Sport and National Identity|Politics, Economics and the Globalization of Sport"
  ["Theory, Mind and Method"]="Training Methodologies in Athletics|Sports Psychology|Flow States and Performance|Motivation, Habit and Goal-Setting|Injury Prevention and Recovery|Biofeedback, Tracking and Tech in Training"
  ["Martial Arts and Combat Traditions"]="Martial Arts Systems - Karate, Judo, Kung Fu, BJJ|Weapon-Based Traditions - Fencing, Kendo, Escrima|Philosophical Roots and Spiritual Disciplines|Self-Defense and Practical Application|Cultural Symbolism and Martial Lineages"
  ["Movement and Physical Culture"]="Running, Endurance and Cardio Disciplines|Strength Training and Calisthenics|Flexibility and Mobility Practices|Functional Fitness and Movement Therapy|Parkour and Natural Movement|Dance and Expressive Body Practice"
  ["Outdoor Skills, Recreation and Adventure"]="Outdoor Survival Skills|Hiking, Backpacking and Orienteering|Rock Climbing and Bouldering|Camping Systems and Gear|Paddling, Rowing and Water Navigation|Winter Sports and Cold Resilience|Adventure Planning and Risk Assessment"
  ["Games, Play and Social Recreation"]="Board Games and Roleplaying Systems|Strategy and Simulation Sports|Movement-Based Social Games|Community Recreation Models|Digital Sports and eSports|Leisure Theory and the Philosophy of Play"
)
#Varia
declare -A VARIA_TOPICS
VARIA_TOPICS=(
  ["Pseudoscience"]="Astrology|Homeopathy|Crystal Healing|Alternative Medicine|Conspiracy Theories"
  ["Urban Legends"]="Creepy Pasta|Internet Urban Legends|Folklore and Mythology|Modern Folklore"
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
  done

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
  echo "You did it! 🎉"
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