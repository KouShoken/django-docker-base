FROM python:3.11

# 创建工作目录
RUN mkdir /app
WORKDIR /app

# Install Python Requirements
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

# 添加当前目录到 Docker 容器的工作目录
COPY . /app/

# 收集静态文件
RUN python manage.py collectstatic --noinput

# 安装和配置nginx
RUN apt-get update && apt-get install -y nginx
COPY .container_cfg/nginx.conf /etc/nginx

# Copy start script and make it executable
COPY ./container_cfg/start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start Gunicorn and Nginx
CMD ["/app/start.sh"]
