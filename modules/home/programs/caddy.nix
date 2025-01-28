{ pkgs, config, ... }: {

  imports = [];

  home.packages = with pkgs; [
    caddy
  ];

  services.caddy = {
    enable = true;
    caddyfile = ''
      :443 {
        reverse_proxy 127.0.0.1:8080
        tls internal
      }
      vertex-oauth.test {
        reverse_proxy 127.0.0.1:8080
        tls internal
      }
    '';
    config = {
      email = "joshuabates@gmail.com"; # Used for Let's Encrypt notifications
    };
  };
}
