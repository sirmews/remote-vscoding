FROM codercom/code-server

USER root

RUN apt-get update && apt-get install -y ca-certificates gnupg2

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Apply VS Code settings
COPY vscode/settings.json .local/share/code-server/User/settings.json

# Install the desired Node.js version into `/usr/local/`
ENV NODE_VERSION=16.15.0
RUN curl \
https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
 | tar xzfv - \
  --exclude CHANGELOG.md \
  --exclude LICENSE \
  --exclude README.md \
  --strip-components 1 -C /usr/local/

# Install the Yarn package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

USER coder

WORKDIR /home/coder

EXPOSE 8080

CMD ["code-server"]

