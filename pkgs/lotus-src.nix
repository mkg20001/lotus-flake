{ fetchFromGitHub, lib }:

fetchFromGitHub {
  owner = "filecoin-project";
  repo = "lotus";
  rev = "v1.11.1";
  sha256 = "sha256-Csk/GD1QPIvSHj0u0BarYrhALOC2pp5tzHOub8dKek8=";
  fetchSubmodules = true;
}
