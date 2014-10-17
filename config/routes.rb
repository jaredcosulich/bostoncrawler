Bostoncrawler::Application.routes.draw do
  root to: 'dashboard#index' 
  get '/dashboard/jobs_pages', to: 'dashboard#jobs_pages', as: 'jobs_pages' 
end
