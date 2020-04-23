using System;
using UnityEngine;

public class BetterJump : MonoBehaviour
{
    public float fallMutiplier = 2.5f;
    public float lowJumpMultiplier = 1f;


    private Rigidbody2D rigidbody2D;

    private void Awake()
    {
        rigidbody2D = GetComponent<Rigidbody2D>();
    }


    private void FixedUpdate()
    {
        if (rigidbody2D.velocity.y < 0)
        {
            rigidbody2D.velocity += Vector2.up * Physics2D.gravity.y * (fallMutiplier - 1) * Time.deltaTime;
        }
        else if( rigidbody2D.velocity.y > 0 && !Input.GetKey(KeyCode.Space) )
        {
            rigidbody2D.velocity += Vector2.up * Physics2D.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;
        }
    }
}
