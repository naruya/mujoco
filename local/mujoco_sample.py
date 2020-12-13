import gym

# mujoco+gymのテスト
env = gym.make('Humanoid-v1')
env.reset()
for i in range(100):
    env.step(env.action_space.sample())
    env.render()
env.close()
