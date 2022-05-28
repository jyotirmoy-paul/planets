# reads the following metrics for the planets web
# 1. total_web_page_visits : Total no of website visits
# 2. dashboard_page_visits : Total no of dashboard page visits
# 3. planet_page_visits : Total no of planet page visits
# 4. auto_solver_used_counter : Count of auto solver used
# 5. github_link_clicked_counter : Count of github link clicked
domain=fph-planets.web.app
webPageVisits=total_web_page_visits
dashboardPageVisits=dashboard_page_visits
puzzlePageVisits=puzzle_page_visits
autoSolverUsedCounter=auto_solver_used_counter
githubLinkClickedCounter=github_link_clicked_counter

# https://api.countapi.xyz/hit/$kProjectDomain/$counterKey
baseApi="https://api.countapi.xyz/get"
webPageVisitApi="$baseApi/$domain/$webPageVisits"
dashboardPageVisitApi="$baseApi/$domain/$dashboardPageVisits"
puzzlePageVisitApi="$baseApi/$domain/$puzzlePageVisits"
autoSolverUsedApi="$baseApi/$domain/$autoSolverUsedCounter"
githubLinkClickedApi="$baseApi/$domain/$githubLinkClickedCounter"


webPageVisitCount=$(curl -s $webPageVisitApi | cut -d ":" -f 2 | cut -d "}" -f 1)
dashboardPageVisitCount=$(curl -s $dashboardPageVisitApi | cut -d ":" -f 2 | cut -d "}" -f 1)
puzzlePageVisitCount=$(curl -s $puzzlePageVisitApi | cut -d ":" -f 2 | cut -d "}" -f 1)
autoSolverUsedCount=$(curl -s $autoSolverUsedApi | cut -d ":" -f 2 | cut -d "}" -f 1)
githubLinkClickedCount=$(curl -s $githubLinkClickedApi | cut -d ":" -f 2 | cut -d "}" -f 1)

echo "Web page visits: $webPageVisitCount"
echo "Dashboard page visits: $dashboardPageVisitCount"
echo "Puzzle page visits: $puzzlePageVisitCount"
echo "Auto solver used: $autoSolverUsedCount"
echo "Github project repo visits: $githubLinkClickedCount"