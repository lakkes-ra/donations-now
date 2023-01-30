<p align="center"><img src="https://statamic.com/assets/branding/Statamic-Logo+Wordmark-Rad.svg" width="400" alt="Statamic Logo" /></p>
Automated Statamic V3 initialization

## Installation

### Prerequirements
1. Docker and Docker Compose
2. Traefik container running (https://git.visuellverstehen.de/visuel/traefik_configuration)

### Initializing hosting environment
1. Create a new server via Forge.
2. Add the vvcode.visuel.dev subdomain and link it to the newly created server.
3. Add a Let's Encrypt SSL certificate for this new subdomain via forge.

### Initializing a hot and fresh project
1. Run `git clone git@git.visuellverstehen.de:visuel/stinit.git vvcode-website`
2. Run `cd vvcode-website`
3. Run `./stinit`
4. Enjoy the flat file web revolution 🚀

## Documentation
There are great docs out there: [statamic.dev](https://statamic.dev)

### Test User
To create a fresh user for local testing, run `php please make:user`

### Pretend you are a rocket
Why? Why not? Enjoy your freedom and the fresh air. 🚀

## Tips

### Something went wrong? Start over.
1. Run `docker-compose down` inside the `vvcode-website` directory
3. Run `docker image rm vvcode-website_tooling`
4. Run `docker image rm vvcode-website_application`
5. Run `rm vvcode-website` and start over

### Deployment with GitLab CI
1. Uncomment the deploy stage in .gitlab-ci.yml
2. Push to the main branch
