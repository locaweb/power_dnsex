FROM elixir:1.8

RUN mkdir -p /opt/power_dnsex/
ENV LC_ALL C.UTF-8
WORKDIR /opt/power_dnsex

ADD mix.exs /opt/power_dnsex/mix.exs
ADD mix.lock /opt/power_dnsex/mix.lock
RUN mix do local.hex --force, local.rebar --force

EXPOSE 4000
CMD ["/bin/bash"]
