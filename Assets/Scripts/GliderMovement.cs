using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

public class GliderMovement : MonoBehaviour
{
    public GameObject PlaceHolder;
    public Text generationsText;
    public Text cellCountText;
    public GameObject creditPanel;
    public Text generationTextAtEnd;

    public static int width = 100;
    public static int height = 100;
    public static Transform[,] grid = new Transform[width,height];
    private static int generation = 0;
    private float previousTime;
    private float previousMoveTime;
    private float previousBulletTime;
    public float updateTime = 0.5f;

    private int cellCount = 0;
    private int minCellCount = 99999;
    private int maxCellCount = 0;

    private Vector3 lastDirection = new Vector3(1, 0,0);


    public GameObject[] bulletPrefabs;
    private ArrayList bullets = new ArrayList();
    
    private AudioManager audioManager;

    
    // Start is called before the first frame update
    void Start()
    {
        audioManager = GetComponent<AudioManager>();
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 direction = new Vector3();
        
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            direction = new Vector3(-1, 0,0);
            lastDirection = direction;
            transform.rotation = Quaternion.Euler(0, 0, 180);
            
            
        }else if (Input.GetKey(KeyCode.RightArrow))
        {
            direction = new Vector3(1, 0,0);
            lastDirection = direction;
            transform.rotation = Quaternion.Euler(0, 0, 0);


        }else if (Input.GetKey(KeyCode.UpArrow))
        {
            direction = new Vector3(0, 1,0);
            lastDirection = direction;
            transform.rotation = Quaternion.Euler(0, 0, 90);


        }else if (Input.GetKey(KeyCode.DownArrow))
        {
            direction = new Vector3(0, -1,0);
            lastDirection = direction;
            transform.rotation = Quaternion.Euler(0, 0, 270);


        }

        if (Input.GetKey(KeyCode.G))
        {
            SetGameOver();

        }
        
        if (Input.GetKey(KeyCode.C))
        {
            if (Time.time - previousBulletTime >= updateTime*3 )
            {
                audioManager.PlaySound("bullet_shoot");
                // Spawn 
                GameObject go = Instantiate( bulletPrefabs[ Mathf.RoundToInt(Random.Range(0, bulletPrefabs.Length)) ], transform.position + (lastDirection * 3), Quaternion.identity);
                go.AddComponent<Bullet>().SetDirection(lastDirection);
                // if any neighbour on all parts
            
                bullets.Add(go);

                previousBulletTime = Time.time;
            }


        }

        if (Time.time - previousMoveTime >= updateTime/3)
        {
            transform.position += direction;
            if (!ValidMove())
            {
                transform.position -= direction;
            }
            else
            {
                if (direction != new Vector3())
                {
                    audioManager.PlaySound("player_move");
                }
            }
            
            previousMoveTime = Time.time;

        }

        if (Time.time - previousTime >= updateTime )
        {


            foreach (GameObject go in bullets)
            {
                if (AnyNeighboursOfBullet(go))
                {
                    go.AddComponent<GoLCell>();
                    // AddToGrid(go);
                    // go.GetComponent<Bullet>().enabled = false;
                    bullets.Remove(go);
                }
                else
                {
                    go.GetComponent<Bullet>().Move();
                    if (go.transform.position.x < -5 || go.transform.position.x > width + 5 ||
                        go.transform.position.y < -5 || go.transform.position.y > height + 5)
                    {
                        bullets.Remove(go);
                        Destroy(go);
                    }
                }
            }

            
            StartCoroutine( ApplyConway() );


            // conway update
            previousTime = Time.time;
        }
        
        generationsText.text = generation.ToString();
    }
    
    bool ValidMove()
    {
        foreach (Transform child in transform)
        {
            int roundedX = Mathf.RoundToInt(child.transform.position.x);
            int roundedY = Mathf.RoundToInt(child.transform.position.y);

            if (roundedX < 0 || roundedX >= width || roundedY < 0 || roundedY >= height)
            {
                return false;
            }

            if (grid[roundedX, roundedY] != null )
            {
                return false;
            }
        }

        return true;
    }

    bool AnyNeighboursOfBullet(GameObject b)
    {
        foreach (Transform child in b.transform)
        {
            int x = Mathf.RoundToInt(child.transform.position.x);
            int y = Mathf.RoundToInt(child.transform.position.y);

            int count = 0;
            for (int i = x-1; i <= x+1; i++)
            {
                for (int j = y-1; j <= y+1; j++)
                {
                    if ( i < 0 || i >= width || j < 0 || j >= height )
                    {
                        continue;
                    }

                    if (grid[i, j] != null )
                    {
                        return true;
                    }

                }
            }

        }

        return false;
    }
    
    public void AddToGrid(GameObject go)
    {
        foreach (Transform child in go.transform)
        {
            int roundedX = Mathf.RoundToInt(child.transform.position.x);
            int roundedY = Mathf.RoundToInt(child.transform.position.y);

            grid[roundedX, roundedY] = transform;
            //Debug.Log("ADDED AT " + roundedX + " " + roundedY );
        }

    }
    
    public IEnumerator ApplyConway()
    {
        generation++;
        // FindObjectOfType<SpawnBlock>().generationCount.text = generation.ToString();
        
        // generate bool map from grid
        bool [,] currentGrid = new bool[width,height];

        cellCount = 0;
        for (int i = 0; i < width; i++)
        {
            for (int j = 0; j < height; j++)
            {
                if (grid[i, j] != null)
                {
                    cellCount++;
                    currentGrid[i, j] = true;
                }
                else
                {
                    currentGrid[i, j] = false;
                }
            }
        }
        
        bool [,] nextStepGrid = new bool[width,height];
        for (int i = 0; i < width; i++)
        {
            for (int j = 0; j < height; j++)
            {
                int c = CountNeighbours(currentGrid, i, j);
                if ( currentGrid[i,j] && c < 2)
                {
                    // Debug.Log("Isolation "+ "c=" + c + ", i,j=" + i + "," + j);
                    nextStepGrid[i, j] = false;
                    
                    Destroy( grid[i,j].gameObject, 0f );
                    grid[i, j] = null;
                    
                }else if ( currentGrid[i,j] && (c == 2 || c == 3))
                {
                    // Debug.Log("Unchanged  "+ "c=" + c + ", i,j=" + i + "," + j);
                    nextStepGrid[i, j] = true;

                    if (grid[i, j] != null)
                    {
                        Destroy( grid[i,j].gameObject, 0f );
                        grid[i, j] = null;
                    }
                    
                    GameObject go = Instantiate( PlaceHolder, new Vector3(i, j, 0), Quaternion.identity);
                    grid[i, j] = go.transform;
                }else if ( currentGrid[i,j] && c > 3)
                {
                    // Debug.Log("Overcrowded "+ "c=" + c + ", i,j=" + i + "," + j);
                    nextStepGrid[i, j] = false;
                    
                    Destroy( grid[i,j].gameObject, 0f );
                    grid[i, j] = null;
                    
                }else if ( !currentGrid[i,j] && c == 3 )
                {
                    // Debug.Log("ALIVE"+ "c=" + c + ", i,j=" + i + "," + j);
                    nextStepGrid[i, j] = true;
                    
                    GameObject go = Instantiate( PlaceHolder, new Vector3(i, j, 0), Quaternion.identity);
                    grid[i, j] = go.transform;
                }
            }
        }

        minCellCount = Math.Min(minCellCount, cellCount);
        maxCellCount = Math.Max(maxCellCount, cellCount);
        cellCountText.text = cellCount.ToString() + "   [ min=" +  minCellCount + ", max="+ maxCellCount + "]";

        
        if ( cellCount <= 0 )
        {
            SetGameOver();
        }
        
        yield return null;
    }

    int CountNeighbours(bool[,] cgrid, int x, int y)
    {
        int count = 0;
        for (int i = x-1; i <= x+1; i++)
        {
            for (int j = y-1; j <= y+1; j++)
            {
                if ((i == x && j ==y)  || i < 0 || i >= width || j < 0 || j >= height )
                {
                    continue;
                }

                if (cgrid[i, j])
                {
                    count++;
                }

            }
        }

        return count;
    }

    public void SetGameOver()
    {
        Debug.Log("GAME OVER");
        creditPanel.SetActive(true);
        generationTextAtEnd.text = generation.ToString() + " Generations";
        this.enabled = false;
    }
}
