token=$(\
 ssh -i ../key.private -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 10025 \
     tim@"$1" "docker swarm join-token worker" \
   | grep '[-][-]token' \
   | awk '{print $5}' \
)
echo '{"token": "'"$token"'"}'
