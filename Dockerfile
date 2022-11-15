#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:2.1.816-stretch AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/aspnet:2.1.28-stretch-slim AS build
WORKDIR /src
ls
COPY ["SubQuip.Web/SubQuip.WebApi.csproj", "SubQuip.Web/"]
COPY ["SubQuip.Service/SubQuip.Business.csproj", "SubQuip.Service/"]
COPY ["SubQuip.Common/SubQuip.Common.csproj", "SubQuip.Common/"]
COPY ["SubQuip.Entity/SubQuip.Entity.csproj", "SubQuip.Entity/"]
COPY ["SubQuip.Data/SubQuip.Data.csproj", "SubQuip.Data/"]
COPY ["SubQuip.Model/SubQuip.ViewModel.csproj", "SubQuip.Model/"]
RUN dotnet restore "SubQuip.Web/SubQuip.WebApi.csproj"
COPY . .
WORKDIR "/src/SubQuip.Web"
RUN dotnet build "SubQuip.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SubQuip.WebApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SubQuip.WebApi.dll"]