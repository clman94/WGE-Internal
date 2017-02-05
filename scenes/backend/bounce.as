
float g = -1;

void accelerate_z(entity pEntity, float pTime, float pAccel, float pVel = 0) {
  
  float z_vel = pVel;
  
  for(float t = 0; t <= pTime; t += get_delta()) {
    
    set_z(get_player(), get_z(get_player()) + z_vel * get_delta() + (1/2) * pAccel * pow(get_delta(), 2));
    
    z_vel += pAccel * get_delta();
    
    yield();
  }
  
}

void bounce(float pHeight, float pTime) {
  
  float velocity = (pHeight - (.5 * g * pow(pTime, 2)));
  
  accelerate_z(get_player(), pTime, g, velocity);
  
}

void bounce(float pVel) {
  
  float t = (-2 * pVel) / g;
  
  accelerate_z(get_player(), t, g, pVel);
  
}

