FROM mcr.microsoft.com/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY SubQuip.Web.sln ./
COPY SubQuip.Common/*.csproj ./SubQuip.Common/
COPY SubQuip.Data/*.csproj ./SubQuip.Data/
COPY SubQuip.Entity/*.csproj ./SubQuip.Entity/
COPY SubQuip.Model/*.csproj ./SubQuip.Model/
COPY SubQuip.Service/*.csproj ./SubQuip.Service/
COPY SubQuip.Web/*.csproj ./SubQuip.Web/

RUN dotnet restore
COPY . .

WORKDIR /src/SubQuip.Web
RUN dotnet restore && dotnet build --no-restore -c Release -o /app

#WORKDIR /src/SubQuip.Common
#RUN dotnet build --no-restore -c Release -o /app

#WORKDIR /src/SubQuip.Data
#RUN dotnet build --no-restore -c Release -o /app

#WORKDIR /src/SubQuip.Entity
#RUN dotnet build --no-restore -c Release -o /app

##WORKDIR /src/SubQuip.Model
#RUN dotnet build --no-restore -c Release -o /app

#WORKDIR /src/SubQuip.Service
#RUN dotnet build --no-restore -c Release -o /app


FROM build AS publish
RUN dotnet publish --no-restore -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SubQuip.WebApi.dll"]
